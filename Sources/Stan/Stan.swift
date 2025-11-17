// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import Foundation
import ArgumentParser

@main
struct Stan: ParsableCommand {
  mutating func run() throws {
    let modelName: String = "bernoulli"
    let fileManager = FileManager.default
    let documentsUrl = fileManager.urls(for: .documentDirectory,
                                        in: .userDomainMask)[0] as NSURL
    let dirUrl = documentsUrl.appendingPathComponent("Stan/\(modelName)")
    
    let bernouli_stan = """
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
                                modelName: modelName)
    
    print(result)
    
    if result == ("Compilation needed.", "") {
      print("Compiling...")
      result = stanCompile(dirUrl: dirUrl!,
                           modelName: modelName)
      print(result)
    }
    
    if result.1 == "" {
      result = stanSample(dirUrl: dirUrl!,
                      modelName: modelName)
      print(result)
    }
    
    if result.1 == "" {
      result = getSampleResult(dirUrl: dirUrl!,
                               modelName: modelName)
      print(result)
    }
    
    if result.1 == "" {
      let result = stanSummary(dirUrl: dirUrl!,
                                modelName: modelName,
                                cmdstan: cmdstan)
      print(result)
    }
    
    if result.1 == "" {
      let result = extractStanSummary(dirUrl: dirUrl!,
                                       modelName: modelName)
      print(result)
    }
    
    if result.1 == "" {
      let opt = stanOptimize(dirUrl: dirUrl!,
                         modelName: modelName,
                         arguments: ["optimize", "save_iterations=true"])
      print(opt)
    }

    if result.1 == "" {
      let opt = getOptimizeResult(dirUrl: dirUrl!,
                         modelName: modelName)
      print(opt)
    }
    
    if result.1 == "" {
      let result = stanPathfinder(dirUrl: dirUrl!,
                         modelName: modelName)
      print(result)
    }

//    if result.1 == "" {
//      let pf = getPathfinderResult(dirUrl: dirUrl!,
//                         modelName: modelName)
//      print(pf)
//    }

  }
}
