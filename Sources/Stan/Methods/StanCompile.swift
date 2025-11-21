//
//  StanCompile.swift
//  Stan
//
//  Created by Robert Goedman on 11/13/25.
//

import Foundation

public func stanCompile(dirUrl: URL,
                        modelName: String,
                        cmdstan: String) -> (String, String) {
  
  let modelPath = "\(dirUrl.path)/\(modelName)"

  let result = swiftSyncFileExec(program: "/usr/bin/make",
                                 arguments: ["-C", cmdstan, "\(modelPath)"],
                                 method: "(\(modelName) executable)")
  return result
}
