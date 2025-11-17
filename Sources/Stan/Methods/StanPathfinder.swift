//
//  Optimize.swift
//  
//
//  Created by Robert Goedman on 10/30/25.
//

import Foundation

public func stanPathfinder(dirUrl: URL,
                       modelName: String,
                       arguments: [String] = ["pathfinder"]) -> (String, String) {
  var args = arguments
  args.append(contentsOf: ["data", "file=" + dirUrl.path + "/" + modelName + ".data.json"])
  args.append(contentsOf: ["output", "file=" + dirUrl.path + "/" + modelName + "_pathfinder.csv"])
  //print(args)
  return swiftSyncFileExec(program: dirUrl.path + "/" + modelName,
                           arguments: args)
}

public func getPathfinderResult(result: String,
                                dirUrl: URL,
                                modelName: String) -> [String] {
  
  var theResult: [String] = []
  var copy = false
  
  do {
    do {
      let myStrings = result.components(separatedBy: .newlines)
      for result in myStrings {
        //print(result.count)
        if result.count > 4 {
          //let index = result.index(result.startIndex, offsetBy: 0)
          //let index4 = result.index(result.startIndex, offsetBy: 4)
          //let contents = result[index...index4]
          if !copy && result.count == 25 && result == "num_threads = 1 (Default)" {
            copy = true
            continue
          }
          if copy {
            theResult.append(result + "\n")
          }
        }
      }
    }
  }
  
  //TODO: Reformat into a proper csv format?
  let _ = createCSV(from: theResult,
                    dirUrl: dirUrl,
                    modelName: modelName,
                    kind: "pathfinder")
  
  return theResult
}
