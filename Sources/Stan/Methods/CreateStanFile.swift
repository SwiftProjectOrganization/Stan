//
//  CreateCSVFiles.swift
//
//
//  Created by Robert Goedman on 10/31/25.
//

import Foundation

public func createStanFile(_ data: String,
                           dirUrl: URL,
                           modelName: String) -> (String, String) {
  
  let fileManager = FileManager.default
  
  do {
    //var isDirectory: ObjCBool = false
    let filePath: String = dirUrl.path + "/" + modelName + ".stan"
    let fileUrl = URL(fileURLWithPath: String(describing: filePath))
    if fileManager.fileExists(atPath: filePath) {
      //print("Reading file \(fileUrl.path).")
      do {
        let fileContent = try String(contentsOf: fileUrl, encoding: .utf8)
        if fileContent == data {
          //print("Stan file did not change.")
          let binaryPath: String = dirUrl.path + "/" + modelName
          //print(binaryPath)
          if fileManager.fileExists(atPath: binaryPath) {
            //print("Binary available.")
            return("Stan model file has not changed, no compilation needed.", "")
          } else {
            return ("Compilation needed.", "")
          }
        }
        do {
          try fileManager.removeItem(atPath: filePath)
          print("\(filePath) deleted successfully, will attempt to create a new one.")
        } catch {
          return ("", "Error deleting file \(filePath): \(error)")
        }
      } catch {
        return ("", "Error reading file \(String(describing: filePath)) (error: \(error))")
      }
    }
    do {
      let fileUrl = URL(fileURLWithPath: String(describing: filePath))
      try data.write(to: fileUrl, atomically: true, encoding: .utf8)
      print("New Stan model file created.")
      return ("Compilation needed.", "")
      
    } catch {
      return ("", "Error creating Stan model file: \(error)")
    }
  }
}
