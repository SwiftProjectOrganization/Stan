//
//  Sample.swift
//
//
//  Created by Robert Goedman on 10/30/25.
//

import Foundation

public func stanSummary(dirUrl: URL,
                        modelName: String,
                        cmdstan: String) -> (String, String) {
  let fileManager = FileManager.default
  let filePath = dirUrl.path + "/" + modelName + "_summary.csv"
  
  do {
    var isDirectory: ObjCBool = false
    if fileManager.fileExists(atPath: filePath, isDirectory: &isDirectory) {
      try fileManager.removeItem(atPath: filePath)
      //print("\(model)_summary.csv deleted successfully, will create a new one.")
    }
  } catch {
    print("Error deleting file \(modelName)_summary.csv: \(error)")
  }
  let result = swiftSyncFileExec(program: cmdstan + "/bin/stansummary",
                                 arguments: [ dirUrl.path + "/" + modelName + "_output_1.csv",
                                              dirUrl.path + "/" + modelName + "_output_2.csv",
                                              dirUrl.path + "/" + modelName + "_output_3.csv",
                                              dirUrl.path + "/" + modelName + "_output_4.csv",
                                              "--csv_filename", dirUrl.path + "/" + modelName + "_summary.csv"],
                                 method: "")
  
  return result
}


