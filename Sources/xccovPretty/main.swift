//
//  main.swift
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


/// `StandardErrorStream`s are `OutputStream`s that write to the standard error device.
///
/// They can be used with `print(_:to:)` to write console output to standard error:
///
/// ```
/// var standardError = StandardErrorStream()
/// print("Error: …", to: standardError)
/// ```
struct StandardErrorStream : TextOutputStream {
    mutating func write(_ string: String) {
        fputs(string, stderr)
    }
}


/// Prints `message` to the standard error stream and exits with the specified status code.
///
/// - Parameters:
///   - status: The status code with which to exit.
///   - message: The message to output to the standard error stream.
/// - Returns: Never.
func exit(status: Int32, _ message: String) -> Never {
    var standardErrorStream = StandardErrorStream()
    print(message, to: &standardErrorStream)
    exit(status)
}


/// Decodes the JSON data from the specified file handle into a `ProjectCodeCoverageReport`. If the data cannot be
/// decoded successfully, prints an error and exits with status 1.
///
/// - Returns: The JSON-decoded project code coverage report.
func jsonDecodedProjectReport(from fileHandle: FileHandle) -> ProjectCodeCoverageReport {
    let inputData = fileHandle.readDataToEndOfFile()

    do {
        return try JSONDecoder().decode(ProjectCodeCoverageReport.self, from: inputData)
    } catch {
        exit(status: 1, "Could not decode input: \(error.localizedDescription)")
    }
}


func includedTargetNames() -> [String]? {
    guard let includeTargetsString = UserDefaults.standard.string(forKey: "includeTargets") else {
        return nil
    }

    let targetNames = includeTargetsString.split(separator: ",", omittingEmptySubsequences: true).map(String.init(_:))
    return targetNames.isEmpty ? nil : targetNames
}


// Decode the project report from standard input, create a code coverage table, and print it to the console
let projectReport = jsonDecodedProjectReport(from: .standardInput)
let codeCoverageTable = CodeCoverageTable(projectReport: projectReport, includedTargetNames: includedTargetNames())
print(codeCoverageTable)
