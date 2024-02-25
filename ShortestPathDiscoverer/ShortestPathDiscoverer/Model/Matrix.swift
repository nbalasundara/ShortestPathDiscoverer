//
//  Matrix.swift
//  ShortestPathDiscoverer
//
//  Created by natarajan b on 2/24/24.
//

import Foundation

///
/// A generic 2-D matrix container for Numeric, Comparable elements
/// Enables subscipt notation for 2-D matrices.
///
/// Only constraint on T is it be Numeric and Comparable.
public class Matrix<T: Numeric & Comparable> {
    public let rows: Int
    public let columns: Int
    private var array: [[T]]
    
    ///
    /// Creator with given rows and column dimensions.
    public init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        array = .init(repeating:.init(repeating:0 as T, count:columns), count: rows)
    }
    
    ///
    /// Sunscript access with [row, column] syntax instead of [][] syntax for 2-D array.
    /// - Parameters:
    ///   - row: The row index. indicies start at 0
    ///   - column : The column index. Indicies start at 0
    ///
    ///  Does precondition checks for array indices not exceeding the array bounds.
    ///
    public subscript(row: Int, column: Int) -> T {
        get {
            precondition(row < rows, "Row \(row) Index is out of range.  [\(rows), \(columns)])")
            precondition(column < columns, "Column \(column) Index is out of range : [\(rows), \(columns)])")
            return array[row][column]
        }
        set {
            precondition(row < rows, "Row \(row) Index is out of range.  [\(rows), \(columns)])")
            precondition(column < columns, "Column \(column) Index is out of range : [\(rows), \(columns)])")
            array[row][column] = newValue
        }
    }
}

///
/// An extension of the generic matrix adapted for closed edge and
/// for finding the shortest path
extension Matrix {
    ///
    /// - Parameters:
    ///   - column :The column index of the column for which the row index with the minimum value is to
    ///             returned
    ///
    /// - Returns: the minium row index with lowest value for the given column
    ///
    private func minRowIdx(column : Int) -> Int {
        var minValue : T
        var idx : Int = 0
        minValue = self[idx, column]
        for row in 1..<rows {
            if (self[row, column] < minValue) {
                minValue = self[row, column]
                idx = row
            }
        }
        return idx
    }
    ///
    /// Find the previous row index relative to the given row index.
    ///
    /// - Parameters:
    ///     - row : The refernce row relative to which the previous row is to be returned
    ///  - Returns:
    ///         The index of the previous row, considering the row edges closed
    /// Previous row relative to the input row, in a closed row edge matrix
    private func p(_ row : Int) -> Int {
        return row - 1 >= 0 ? row - 1 : rows - 1
    }
    
    ///
    /// Find the next row index relative to the given row index.
    ///
    /// - Parameters:
    ///     - row : The refernce row relative to which the next row is to be returned
    ///  - Returns:
    ///         The index of the next row, considering the row edges closed
    private func n(_ row : Int) -> Int {
        row+1 < rows ? row + 1 : 0
    }
    
    ///
    /// Finds the shortest path in a closed row edge Matrix, Sweeping
    /// from left to right across columns given the constraint not to
    /// exceed the maximum path length given by the bound.
    /// - Parameters:
    ///     - bound : The maximum path length allowed for the shortest path
    ///
    /// - Returns is a tuple:
    ///    - Boolean indicating if the search was successful,
    ///    - The length of the path,
    ///    - And the discovered path.
    func shortestPath(bound: T) async -> (Bool, T, [Int])? {
        let accumulate = Matrix<T>(rows: rows, columns: columns)
        
        // Initialize first column of the accumulate
        for row in 0..<rows {
            accumulate[row, 0] = self[row, 0]
        }
        
        // Sweep from left to right across columns:
        for column in 1..<columns {
            var hasAtLeastOneShortPath = false;
            for row in 0..<rows {
                accumulate[row, column] = self[row, column]
                + min(accumulate[p(row), column - 1],
                      accumulate[row, column - 1],
                      accumulate[n(row), column - 1])
                if accumulate[row, column] <= bound {
                    hasAtLeastOneShortPath = true;
                }
            }
            
            if (hasAtLeastOneShortPath) {
                continue
            } else {
                return shortestPath(accumulate: accumulate, bound:bound, startingAtColumn: column)
            }
        }
        return shortestPath(accumulate: accumulate, bound:bound, startingAtColumn: columns)
    }
    
    ///
    /// The second pass of the algorithm to find the shortest route once the search for the path
    /// has stopped.
    ///
    /// - Parameters
    ///     - accumulate: is the accumulation of the compuations of the first pass, the search.
    ///     - bound:  is the maximum path length requirement for the solution.
    ///     - startingAtColum:  indicates the column at which the search stopped. The search may have
    ///       been successful or not.
    ///
    /// - Returns is a tuple:
    ///    - Boolean indicating if the search was successful,
    ///    - The length of the path,
    ///    - And the discovered path.

    private func shortestPath(accumulate: Matrix<T>, bound: T, startingAtColumn: Int) -> (Bool, T, [Int])? {
        // We have reached the last column where the value is less than the bound.
        // Trace back to find the path
        var shortestPath = [Int](repeating: 0, count: startingAtColumn)
        
        var minRow = accumulate.minRowIdx(column:startingAtColumn - 1)
        shortestPath[startingAtColumn - 1] = minRow
        
        if (startingAtColumn == 1) {
            return (true, accumulate[minRow, 0], shortestPath)
        }
        
        for column in (0...startingAtColumn - 2).reversed() {
            var minRowNext = p(minRow)
            var minValueNext = accumulate[minRowNext, column]
            if accumulate[minRow, column] < minValueNext {
                minValueNext = accumulate[minRow, column]
                minRowNext = minRow
            }
            if accumulate[n(minRow), column] < minValueNext {
                minRowNext = n(minRow)
            }
            shortestPath[column] = minRowNext
            minRow = minRowNext
        }
        
        return (startingAtColumn==columns, accumulate[shortestPath[startingAtColumn-1], startingAtColumn - 1], shortestPath)
    }
}
