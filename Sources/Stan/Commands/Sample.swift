//
//  OldMain.swift
//  Stan
//
//  Created by Robert Goedman on 11/17/25.
//

import Foundation
import ArgumentParser

public func sample(directory: String,
                   model: String,
                   arguments: [String],
                   cmdstan: String,
                   verbose: Bool,
                   nocompile: Bool,
                   nosummary: Bool) -> (String, String) {
  
  let fileManager = FileManager.default
  let documentsUrl = fileManager.urls(for: .documentDirectory,
                                      in: .userDomainMask)[0] as NSURL
  let dirUrl = documentsUrl.appendingPathComponent("\(directory)/\(model)")
  var isDir: ObjCBool = false
  if !fileManager.fileExists(atPath: dirUrl!.path , isDirectory: &isDir) {
    if verbose {
      print("Given directory \(String(describing: dirUrl!)) does not exist.")
    }
    do {
      try fileManager.createDirectory(at: dirUrl!,
                                      withIntermediateDirectories: true,
                                      attributes: nil)
      if verbose {
        print ("Created directory \(dirUrl!)", "")
      }
    } catch {
      print("", "Could not create directory \(dirUrl!): \(error.localizedDescription)")
      exit(5)
    }
  }

  var result = ("", "")
  
  if !nocompile {
    result = stanCompile(dirUrl: dirUrl!,
                         modelName: model,
                         cmdstan: cmdstan)
    print(result)
  }
  
  if result.1 == "" {
    result = stanSample(dirUrl: dirUrl!,
                        modelName: model,
                        cmdstan: cmdstan)
    print(result)
  } else {
    exit(6) // stanCompile failed
  }
  
  if result.1 == "" {
    result = getSampleResult(dirUrl: dirUrl!,
                             modelName: model)
    if verbose {
      print(result)
    }
  } else {
    exit(7) // stanSample failt
  }
  
  if result.1 == "" {
    let result = stanSummary(dirUrl: dirUrl!,
                             modelName: model,
                             cmdstan: cmdstan)
    print(result)
  } else {
    if !verbose {
      print(result)
    }
    exit(8) // getSampleResults failed
  }
  
  if result.1 == "" {
    result = extractStanSummary(dirUrl: dirUrl!,
                                    modelName: model)
  } else {
    exit(9) // stanSummary failed
  }
  
  if verbose {
    print(result)
  }
  
  return result
}
