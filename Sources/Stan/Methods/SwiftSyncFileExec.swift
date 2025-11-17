//
//  Basics.swift
//
//
//  Created by Robert Goedman on 10/5/25.
//

import Cocoa
import Foundation

let cmdstan = "/Users/rob/Projects/StanSupport/cmdstan"

func swiftSyncFileExec(program: String,
                       arguments: [String]) -> (String, String) {
  let process = Process()
  process.executableURL = URL(fileURLWithPath: program)
  process.arguments = arguments
  //print(arguments)
  
  let outputPipe = Pipe()
  let errorPipe = Pipe()
  process.standardOutput = outputPipe
  process.standardError = errorPipe
  
  do {
    try process.run()
    
    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(decoding: outputData, as: UTF8.self)
    //print(output)
    let error = String(decoding: errorData, as: UTF8.self)
    //print(error)
    return ("Command `\(program)` completed successfully.","")
  } catch {
    return ("", "Command error: \(error.localizedDescription)")
  }
}
