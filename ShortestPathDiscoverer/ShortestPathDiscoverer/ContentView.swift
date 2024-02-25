//
//  ContentView.swift
//  ShortestPathDiscoverer
//
//  Created by natarajan b on 2/24/24.
//

import SwiftUI

struct ContentView: View {
    @State var inputGrid: String = ""
    @State var output: String = ""
    var body: some View {
        List {
            VStack {
                Text("Input grid").bold()
                Text("Enter below one row per line, column values in the row separated by space. Tap on 'Find the shortest Path' button once done to find the shortest path, if one exists.")
                Divider()
                TextEditor(text: $inputGrid).frame(height: 400)
                    .padding(.horizontal)
                Divider()
                Button("Find the Shortest Path") {
                    do {
                        var result: (Bool, Int, [Int])?
                        Task {
                            output = "Working..."
                            let m : Matrix<Int>? = try Loader.load(inputGrid)
                            guard let inputMatrix = m else {
                                output = "Error loading the grid as presented!"
                                return
                            }
                            
                            result = await inputMatrix.shortestPath(bound: 50)
                            output = (result!.0 ? "Yes" : "No")
                            output.append("\n\(result!.1)\n")
                            for i in 0...result!.2.count - 1 {
                                output.append("\(result!.2[i])")
                                if (i<result!.2.count - 1) {
                                    output.append(" ")
                                }
                            }
                        }
                    }
                }
                Divider()
                Text(output).multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    ContentView(inputGrid: "")
}
