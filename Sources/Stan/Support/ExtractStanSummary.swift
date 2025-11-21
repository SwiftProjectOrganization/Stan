//
//  ExtractStanSummary.swift
//  Stan
//
//  Created by Robert Goedman on 11/14/25.
//

import Foundation

public func extractStanSummary(dirUrl: URL,
                               modelName: String) -> (String, String) {
  
  let fileManager = FileManager.default
  var theResult: String = "name,mean,mcse,stddev,mad,p05,p50,p95,ess_bulk,ess_tail,ess_bulk_per_s,R_hat\n"
  do {
    var isDirectory: ObjCBool = false
    let filePath: String? = dirUrl.path + "/" + modelName + "_summary.csv"
    if fileManager.fileExists(atPath: filePath!, isDirectory: &isDirectory) {
      if let path = filePath {
        replaceNanByNil(path)
        do {
          var count = 0
          //print("Reading file \(path).")
          let data = try String(contentsOfFile: path, encoding: .utf8)
          let myStrings = data.components(separatedBy: .newlines)
          for result in myStrings {
            //print(result)
            if (count > 0) && (count < 9) {
              theResult += result + "\n"
            }
            count += 1
          }
        } catch {
          return ("", error.localizedDescription)
        }
      }
    } else {
      return ("", "\(modelName)_summary.csv not found.")
    }
  }
  
  let result = createCSV(from: [theResult],
                         dirUrl: dirUrl,
                         modelName: modelName,
                         kind: "stansummary")
  
  return result
}
