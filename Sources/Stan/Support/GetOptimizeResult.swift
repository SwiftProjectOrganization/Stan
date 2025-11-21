//
//  getOptimizeResult.swift
//  Stan
//
//  Created by Robert Goedman on 11/20/25.
//

import Foundation

public func getOptimizeResult(dirUrl: URL,
                              modelName: String,) -> (String, String) {
  
  let fileManager = FileManager.default
  let filePath: String? = dirUrl.path + "/" + modelName + "_optimize.csv"
  var theResult: [String] = []
  
  do {
    if fileManager.fileExists(atPath: filePath!) {
      if let path = filePath {
        do {
          let data = try String(contentsOfFile: path, encoding: .utf8)
          let myStrings = data.components(separatedBy: .newlines)
          for result in myStrings {
            if result.count > 0 {
              let index = result.index(result.startIndex, offsetBy: 0)
              let character = result[index]
              if character != "#" {
                //print(result)
                theResult.append(result)
              }
            }
          }
        } catch {
          return ("", error.localizedDescription)
        }
      }
    } else {
      return ("", "\(modelName)_optimize.csv not found.")
    }
  }
  let _ = createCSV(from: theResult,
                    dirUrl: dirUrl,
                    modelName: modelName,
                    kind: "optimize")
  
  return ("Cleaned up file \(modelName)_optimize.csv (no comment lines)", "")
}
