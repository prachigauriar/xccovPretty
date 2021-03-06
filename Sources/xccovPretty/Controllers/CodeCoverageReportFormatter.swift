//
//  CodeCoverageReportFormatter.swift
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


/// `CodeCoverageReportFormatter`s convert `CodeCoverageReport`s into strings. Strings output by the formatter look
/// like: "*lineCoverage* (*coveredLines* of *executableLines*)". For example, if line coverage is 0.8335, covered
/// lines is 85023, and executable lines is 102004, the output string would be "83.35% (85,023 of 102,004)".
struct CodeCoverageReportFormatter {
    /// The number formatter used to format line coverage information.
    private static var lineCoverageFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()


    /// The number formatter used to format line coverage information.
    private static var lineCountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()


    private var lineCoverageFormatter: NumberFormatter {
        type(of: self).lineCoverageFormatter
    }


    private var lineCountFormatter: NumberFormatter {
        type(of: self).lineCountFormatter
    }


    /// Returns a string representation of the specified code coverage report.
    ///
    /// - Parameter report: The code coverage report to format.
    /// - Returns: A string representation of `report`.
    func string(from report: CodeCoverageReport) -> String {
        let lineCoverageString = lineCoverageFormatter.string(from: report.lineCoverage as NSNumber)!
        let coveredLinesString = lineCountFormatter.string(from: report.coveredLines as NSNumber)!
        let executableLinesString = lineCountFormatter.string(from: report.executableLines as NSNumber)!
        return "\(lineCoverageString) (\(coveredLinesString) of \(executableLinesString))"
    }
}
