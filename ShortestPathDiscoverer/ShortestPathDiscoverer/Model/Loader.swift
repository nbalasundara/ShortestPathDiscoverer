//
//  Loader.swift
//  ShortestPathDiscoverer
//
//  Created by natarajan b on 2/24/24.
//
// This class loads a matrix from String input
//
//
import Foundation

///
/// Loader is a  utility class to load a 2D grid into a 2D Matrix from a string represenation.
class Loader {
    ///
    /// Loads a given input string representation of a 2D grid into a 2D matrix
    /// Does minimal 'cleanup' to remove extra spaces, lines without content etc., to be a bit robust
    /// 
    /// - Parameters:
    ///    - input : The String is a sequence of lines separed by newline.
    ///          Each line corresponds to a row.
    ///          Within each line the values are column values for that row, separated by a comma(',')
    ///
    /// - Returns :A 2-D matrix if the load is successful, otherwise nil
    /// - Throws: Throws error by any of  system functions that had thrown unexpectdely due to malformed input
    ///
    static func load(_ input : String) throws -> Matrix<Int>?  {
        let rows : [String] = input.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of:"[\n]+", with:"\n")
            .components(separatedBy: "\n")
        let firstColumn = rows[0].replacingOccurrences(of:"[' ']+", with:" ").components(separatedBy: " ")
        
        let gridMatrix : Matrix<Int> = Matrix<Int>(rows:rows.count, columns:firstColumn.count)
        var rowNum = 0
        for row in rows {
            var columnNum = 0
            let columns = row.replacingOccurrences(of:"[' ']+", with:" ").components(separatedBy: " ")
            for column in columns {
                if column == "" {
                    continue
                }
                guard let value = Int(column.trimmingCharacters(in: .whitespacesAndNewlines)) else { return nil }
                gridMatrix[rowNum, columnNum] = value
                columnNum += 1
            }
            rowNum += 1
        }
        return gridMatrix
    }
}
