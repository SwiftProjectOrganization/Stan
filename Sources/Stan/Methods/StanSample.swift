//
//  Sample.swift
//  
//
//  Created by Robert Goedman on 10/30/25.
//

import Foundation

public func stanSample(dirUrl: URL,
                   modelName: String,
                   arguments: [String] = ["sample",
                                          "num_chains=4"]) -> (String, String) {
  var args = arguments
  
  let binaryPath = "\(dirUrl.path)/\(modelName)"
  args.append(contentsOf: ["data", "file=\(binaryPath)" + ".data.json"])
  args.append(contentsOf: ["output", "file=\(binaryPath)" + "_output.csv"])
  
  return swiftSyncFileExec(program: binaryPath,
                           arguments: args)
}
