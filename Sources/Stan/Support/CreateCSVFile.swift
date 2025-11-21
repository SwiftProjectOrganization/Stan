//
//  CreateCSVFiles.swift
//  
//
//  Created by Robert Goedman on 10/31/25.
//

import Foundation

public func createCSV(from data: [String],
                      dirUrl: URL,
                      modelName: String,
                      kind: String) -> (String, String) {
  let fileManager = FileManager.default
  let filePath: String? = dirUrl.path + "/" + modelName + "_" + kind + ".csv"
  
  do {
    var isDirectory: ObjCBool = false
    if fileManager.fileExists(atPath: filePath!, isDirectory: &isDirectory) {
      try fileManager.removeItem(atPath: filePath!)
      //print("\(filePath!.description) deleted successfully, will create a new one.")
      
    }
  } catch {
    return ("", "Error deleting file \(String(describing: filePath))_summary.csv: \(error).")
  }
  
  var csvString: String = ""
  
  for record in data {
    csvString.append("\(record)\n")
  }
  
  let fileURL = URL(string: "\(filePath!.description)")
  
  do {
    try csvString.write(to: fileURL!, atomically: true, encoding: .utf8)
    return ("CSV file created at: \(fileURL!).", "")
  } catch {
    return ("", "Error creating file: \(error).")
  }
}
