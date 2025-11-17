//
//  Optimize.swift
//  
//
//  Created by Robert Goedman on 10/30/25.
//

import Foundation

protocol Decodable {
  init(from decoder: Decoder) throws
}

public func stanOptimize(dirUrl: URL,
                     modelName: String,
                     arguments: [String] = ["pathfinder"]) -> (String, String) {
  var args = arguments
  args.append(contentsOf: ["data", "file=" + dirUrl.path + "/" + modelName + ".data.json"])
  args.append(contentsOf: ["output", "file=" + dirUrl.path + "/" + modelName + "_optimize.csv"])
  //print(args)
  return swiftSyncFileExec(program: dirUrl.path + "/" + modelName,
                           arguments: args)
}


public func getOptimizeResult(dirUrl: URL,
                              modelName: String,) -> [String] {
  
  let fileManager = FileManager.default
  let filePath: String? = dirUrl.path + "/" + modelName + "_optimize.csv"
  var theResult: [String] = []
  
  do {
    var isDirectory: ObjCBool = false
    if fileManager.fileExists(atPath: filePath!, isDirectory: &isDirectory) {
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
          print(error.localizedDescription)
        }
      }
    } else {
      print("\(modelName)_summary.csv not found.")
    }
  }
  let _ = createCSV(from: theResult,
                    dirUrl: dirUrl,
                    modelName: modelName,
                    kind: "optimize")
  
  return theResult
}
