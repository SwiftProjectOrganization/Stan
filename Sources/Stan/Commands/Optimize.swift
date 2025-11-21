//
//  Optimize.swift
//  Stan
//
//  Created by Robert Goedman on 11/17/25.
//

import Foundation

public func optimize(directory: String = "Stan",
                    model: String = "bernoulli",
                    cmdstan: String,
                    verbose: Bool = false) -> (String, String) {
  
  let modelName: String = model
  let fileManager = FileManager.default
  let documentsUrl = fileManager.urls(for: .documentDirectory,
                                      in: .userDomainMask)[0] as NSURL
  let dirUrl = documentsUrl.appendingPathComponent("\(directory)/\(modelName)")
  
  let result = stanOptimize(dirUrl: dirUrl!,
                         modelName: modelName,
                         cmdstan: cmdstan)
  
  if result.1 == "" {
    let result = getOptimizeResult(dirUrl: dirUrl!,
                             modelName: modelName)
    if verbose {
      print(result)
    }
  } else {
    print(result)
    exit(20)
  }
  
  return result
}
  
