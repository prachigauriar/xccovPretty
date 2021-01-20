//
//  CodeCoverageTable.swift
//  xccovPretty
//
//  Created by Prachi Gauriar on 11/6/2018.
//  Copyright © 2018 Prachi Gauriar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation


/// `CodeCoverageTable`s can take a `ProjectCodeCoverageReport` and produce a human-readable textual representation.
struct CodeCoverageTable : CustomStringConvertible {
    /// The `Row` type represents a row in the code coverage table.
    private struct Row {
        /// The name to display for the row.
        let name: String

        /// The coverage summary information to show for the row.
        let coverageSummary: String

        /// The row’s indentation level.
        let indentationLevel: Int


        /// A textual representation of the string given the specified name column width.
        ///
        /// - Parameter nameColumnWidth: The total number of characters that should be used for the row’s name.
        /// - Returns: A textual representation of the row.
        func description(nameColumnWidth: Int) -> String {
            let indentationString = String(repeating: " ", count: indentationWidth)
            let paddingString = String(repeating: " ", count: nameColumnWidth - name.count - indentationWidth)
            return "\(indentationString)\(name)\(paddingString)    \(coverageSummary)"
        }


        /// The number of spaces used to indent the row.
        var indentationWidth: Int {
            return indentationLevel * 4
        }
    }

    /// The table’s rows.
    private let rows: [Row]

    /// Creates a new `CodeCoverageTable` for the specified project code coverage report.
    ///
    /// - Parameter projectReport: The project code coverage report that the `CodeCoverageTable` summarizes.
    init(projectReport: ProjectCodeCoverageReport) {
        self.rows = CodeCoverageTable.rows(for: projectReport)
    }


    var description: String {
        let nameColumnWidth = rows.reduce(0) { (maxWidth, row) in
            return max(maxWidth, row.name.count + row.indentationWidth)
        }

        return rows.reduce(into: "") { (string, row) in
            string.append(row.description(nameColumnWidth: nameColumnWidth))
            string.append("\n")
        }
    }


    // MARK: - Creating Rows

    /// The formatter used to format code coverage summaries for each row.
    private static let codeCoverageReportFormatter = CodeCoverageReportFormatter()

    /// Returns rows that represent the data in the specified project code coverage report.
    ///
    /// - Parameter projectReport: The project code coverage report for which to return rows.
    /// - Returns: The rows containing the project’s code coverage information.
    private static func rows(for projectReport: ProjectCodeCoverageReport) -> [Row] {
        return projectReport.targets.flatMap { rows(for: $0) }
    }


    /// Returns rows that represent the data in the specified target code coverage report.
    ///
    /// - Parameter targetReport: The target code coverage report for which to return rows.
    /// - Returns: The rows containing the target’s code coverage information.
    private static func rows(for targetReport: TargetCodeCoverageReport) -> [Row] {
        // Create a target tree node for the
        let targetTreeNode = CodeCoverageFileNode(name: targetReport.name)
        targetTreeNode.codeCoverageReport = targetReport

        for fileReport in targetReport.files {
            targetTreeNode.addChild(for: fileReport)
        }

        return rows(for: targetTreeNode)
    }


    /// Recursive function that returns the rows for the specified code coverage file node.
    ///
    /// - Parameters:
    ///   - node: The tree node for which to return rows.
    ///   - namePrefix: The string with which to prefix the name of the top-level node. This is used to coalesce
    ///     multiple empty directories into a single node.
    ///   - indentationLevel: The indentation level for the top-level node.
    /// - Returns: The rows containing the node’s code coverage information.
    private static func rows(
        for node: CodeCoverageFileNode,
        namePrefix: String = "",
        indentationLevel: Int = 0
    ) -> [Row] {
        // Generate the name to use for the top-level node
        let name = "\(namePrefix)\(node.name)\(node.isDirectory ? "/" : "")"

        // If the node is a directory with only one element in it, coalesce it into a single item.
        if node.isDirectory && node.children.count == 1 {
            return rows(for: node.children.first!.value, namePrefix: name, indentationLevel: indentationLevel)
        }

        // Create a top-level row
        var fileRows = [
            Row(
                name: name,
                coverageSummary: node.codeCoverageReport.map { codeCoverageReportFormatter.string(from: $0) } ?? "",
                indentationLevel: indentationLevel
            )
        ]

        // Sort the child nodes in ascending order by name
        let sortedChildNodes = node.children
            .sorted { $0.key.localizedCompare($1.key) == .orderedAscending }
            .map { $0.value }

        // Generate rows for each of the children and append them to our list of rows
        fileRows.append(contentsOf: sortedChildNodes.flatMap { rows(for: $0, indentationLevel: indentationLevel + 1) })
        return fileRows
    }
}


/// `CodeCoverageFileNode`s are used to describe the hierarchy of files within a target.
private class CodeCoverageFileNode {
    /// The name of the file.
    let name: String

    /// The code coverage report corresponding to the file. If `nil`, this node represents a directory that has no
    /// coverage data.
    var codeCoverageReport: CodeCoverageReport?

    /// The node’s children. The keys in the dictionary are the children’s names, and the values are their nodes.
    var children: [String : CodeCoverageFileNode] = [:]


    /// Creates a new `CodeCoverageFileNode` with the specified name.
    ///
    /// - Parameter name: The name of the new node.
    init(name: String) {
        self.name = name
    }


    /// Returns whether the node represents a directory.
    var isDirectory: Bool {
        return codeCoverageReport == nil
    }


    /// Adds a child containing information from the file code coverage report.
    ///
    /// - Parameter fileReport: The file code coverage report for which to add a child.
    func addChild(for fileReport: FileCodeCoverageReport) {
        let components = fileReport.path.split(separator: "/", omittingEmptySubsequences: false).map { String($0) }

        // Find or create all the nodes for the file report’s path.
        var currentNode = self
        for component in components {
            if let node = currentNode.children[component] {
                // If a node already exists, use it
                currentNode = node
            } else {
                // Otherwise, create a new node, add it to the current node’s children, and set this node as the current
                // node.
                let newNode = CodeCoverageFileNode(name: component)
                currentNode.children[component] = newNode
                currentNode = newNode
            }
        }

        // Once we get through all the components, currentNode represents the node for our file. Set its fileReport.
        currentNode.codeCoverageReport = fileReport
    }
}
