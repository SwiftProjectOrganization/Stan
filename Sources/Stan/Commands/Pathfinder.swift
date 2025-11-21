//
//  OldMain.swift
//  Stan
//
//  Created by Robert Goedman on 11/17/25.
//

import Foundation

public func pathfinder(directory: String = "Stan",
                    model: String = "bernoulli",
                    arguments: [String] = [],
                    cmdstan: String,
                    verbose: Bool = false) -> (String, String) {
  
  let modelName: String = model
  let fileManager = FileManager.default
  let documentsUrl = fileManager.urls(for: .documentDirectory,
                                      in: .userDomainMask)[0] as NSURL
  let dirUrl = documentsUrl.appendingPathComponent("\(directory)/\(modelName)")
  
  var result = stanPathfinder(dirUrl: dirUrl!,
                         modelName: modelName,
                         cmdstan: cmdstan)
  
  //if verbose {
    print(result)
  //}
  
  if result.1 == "" {
    result = getPathfinderResult(dirUrl: dirUrl!,
                                  modelName: modelName)
    if verbose {
      print(result)
    }
  } else {
    print(result)
    exit(30)
  }
    
  return result
}
  
