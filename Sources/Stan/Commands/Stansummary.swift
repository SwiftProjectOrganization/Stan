//
//  Optimize.swift
//  Stan
//
//  Created by Robert Goedman on 11/17/25.
//

import Foundation

public func stansummary(directory: String = "Stan",
                    model: String = "bernoulli",
                    arguments: [String] = [],
                    cmdstan: String,
                    verbose: Bool = false) -> (String, String) {
  
  let modelName: String = model
  let fileManager = FileManager.default
  let documentsUrl = fileManager.urls(for: .documentDirectory,
                                      in: .userDomainMask)[0] as NSURL
  let dirUrl = documentsUrl.appendingPathComponent("\(directory)/\(modelName)")
  
  let result = stanSummary(dirUrl: dirUrl!,
                         modelName: modelName,
                         cmdstan: cmdstan)
  return result
}
  
