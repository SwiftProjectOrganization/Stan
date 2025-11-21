//
//  compile.swift
//  Stan
//
//  Created by Robert Goedman on 11/17/25.
//

import Foundation

public func compile(directory: String = "Stan",
                    model: String = "bernoulli",
                    arguments: [String] = [],
                    cmdstan: String,
                    verbose: Bool = false) -> (String, String) {
  
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
      return ("", "Could not create directory \(dirUrl!): " + error.localizedDescription)
    }
  }

  let bernouli_stan =
  """
  data {
    int<lower=0> N;
    array[N] int<lower=0, upper=1> y;
  }
  parameters {
    real<lower=0, upper=1> theta;
  }
  model {
    theta ~ beta(1, 1); // uniform prior on interval 0,1
    y ~ bernoulli(theta);
  }
  """
    
  var result = createStanFile(bernouli_stan,
                              dirUrl: dirUrl!,
                              modelName: model,
                              verbose: verbose)
  if result == ("Compilation needed.", "") {
    if verbose {
      print("Compiling...")
    }
    result = stanCompile(dirUrl: dirUrl!,
                         modelName: model,
                         cmdstan: cmdstan)
  }
  
  if result.1 != "" {
    print(result)
    exit(1)
  }
  
  print(result)
  return result
}
