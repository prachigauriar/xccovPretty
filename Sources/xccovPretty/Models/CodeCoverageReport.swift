//
//  CodeCoverageReport.swift
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


/// The `CodeCoverageReport` protocol defines a common interface with which code coverage statistics can be communicated
/// for different units of code.
protocol CodeCoverageReport {
    /// The number of lines covered by tests.
    var coveredLines: Int { get }

    /// The total number of executable lines.
    var executableLines: Int { get }

    /// The proportion of lines covered to executable lines. 0.0 means no lines; 1.0 means 100% of lines.
    var lineCoverage: Double { get }
}
