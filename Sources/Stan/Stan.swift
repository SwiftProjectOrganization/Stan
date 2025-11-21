// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import Foundation
import ArgumentParser

@main
struct Stan: ParsableCommand {
  // Customize your command's help and subcommands by implementing the
  // `configuration` property.
  static let configuration = CommandConfiguration(
    // Optional abstracts and discussions are used for help output.
    abstract: "A wrapper for running cmdstan.",

    // Commands can define a version for automatic '--version' support.
    version: "1.0.0",

    // Pass an array to `subcommands` to set up a nested tree of subcommands.
    // With language support for type-level introspection, this could be
    // provided by automatically finding nested `ParsableCommand` types.
    subcommands: [Compile.self, Sample.self, Optimize.self, Pathfinder.self, Stansummary.self],

    // A default subcommand, when provided, is automatically selected if a
    // subcommand is not given on the command line.
    defaultSubcommand: Sample.self)
}

struct Options: ParsableArguments {
  
  @Flag(
    name: [.customLong("verbose"), .customShort("V")],
    help: "Show more information."
  )
  var verbose: Bool = false
  
  @Flag(
    name: [.customLong("nocompile"), .customShort("C")],
    help: "Don't compile the model before sampling."
  )
  var nocompile: Bool = false
  
  @Flag(
    name: [.customLong("nosummary"), .customShort("S")],
    help: "Don't run stansummary."
  )
  var nosummary: Bool = false
  
  @Option(
    help: "Location of cmdstan.")
  var cmdstan: String?
  
  @Option(
    help: "Directory path.")
  var directory: String?
  
  @Option(
    help: "Model name.")
  var model: String?
  
  @Argument(
    help: "Arguments for method."
  )
  var values: [String] = []
}

extension Stan {
  struct Compile: ParsableCommand {
    static let configuration = CommandConfiguration(
      commandName: "compile",
      abstract: "Compile the Stan model.",
    )
    
    // The `@OptionGroup` attribute includes the flags, options, and
    // arguments defined by another `ParsableArguments` type.
    @OptionGroup var options: Options
    
    mutating func run() {
      
      let environment = ProcessInfo.processInfo.environment
      
      let cmdstan: String
      let directory: String
      let modelName: String

      var command: [String] = [Stan.Compile.configuration.commandName!]
      
      if let cmdstanpath = options.cmdstan {
        cmdstan = cmdstanpath
      } else {
        if let path = environment["CMDSTAN"] {
          //print(path)
          cmdstan = path
        } else {
          cmdstan = "/Users/rob/Projects/StanSupport/cmdstan"
        }
      }
      command.append("cmdstan=\(cmdstan)")
      
      if let dir = options.directory {
        directory = dir
      } else {
        directory = "Stan"
      }
      command.append("directory=\(directory)")

      if let model = options.model {
        modelName = model
      } else {
        modelName = "bernoulli"
      }
      command.append("model=\(modelName)")
      
      command.append(contentsOf: options.values)
      if options.verbose {
        print(command)
      }
      
      let _ = compile(directory: directory,
              model: modelName,
              arguments: options.values,
              cmdstan: cmdstan,
              verbose: options.verbose)
      
    }
  }
}

extension Stan {
  struct Sample: ParsableCommand {
    static let configuration = CommandConfiguration(
      commandName: "sample",
      abstract: "Sample the Stan model."
    )

    // The `@OptionGroup` attribute includes the flags, options, and
    // arguments defined by another `ParsableArguments` type.
    @OptionGroup var options: Options
    
    mutating func run() {
      let environment = ProcessInfo.processInfo.environment
      let cmdstan: String
      let directory: String
      let modelName: String

      var command: [String] = [Stan.Sample.configuration.commandName!]
      
      if options.verbose {
        command.append("verbose=\(options.verbose)")
      }
      
      if options.nocompile {
        command.append("nocompile=\(options.nocompile)")
      }
      
      if options.nosummary {
        command.append("nosummary=\(options.nosummary)")
      }
      
      if let cmdstanpath = options.cmdstan {
        cmdstan = cmdstanpath
      } else {
        if let path = environment["CMDSTAN"] {
          cmdstan = path
        } else {
          cmdstan = "/Users/rob/Projects/StanSupport/cmdstan"
        }
      }
      command.append("cmdstan=\(cmdstan)")

      if let dir = options.directory {
        directory = dir
      } else {
        directory = "Stan"
      }
      command.append("directory=\(directory)")

      if let model = options.model {
        modelName = model
      } else {
        modelName = "bernoulli"
      }
      command.append("model=\(modelName)")
      
      command.append(contentsOf: options.values)
      if options.verbose {
        print(command)
      }

      let _ = sample(directory: directory,
              model: modelName,
              arguments: options.values,
              cmdstan: cmdstan,
              verbose: options.verbose,
              nocompile: options.nocompile,
              nosummary: options.nosummary)

    }
  }
}

extension Stan {
  struct Optimize: ParsableCommand {
    static let configuration = CommandConfiguration(
      commandName: "optimize",
      abstract: "Optimize the Stan model."
    )

    // The `@OptionGroup` attribute includes the flags, options, and
    // arguments defined by another `ParsableArguments` type.
    @OptionGroup var options: Options
    
    mutating func run() {
      let environment = ProcessInfo.processInfo.environment
      let cmdstan: String
      let directory: String
      let modelName: String

      var command: [String] = [Stan.Optimize.configuration.commandName!]
      
      if options.verbose {
        command.append("verbose=\(options.verbose)")
      }
      
      if let cmdstanpath = options.cmdstan {
        cmdstan = cmdstanpath
      } else {
        if let path = environment["CMDSTAN"] {
         cmdstan = path
        } else {
          cmdstan = "/Users/rob/Projects/StanSupport/cmdstan"
        }
      }
      command.append("cmdstan=\(cmdstan)")

      if let dir = options.directory {
        directory = dir
      } else {
        directory = "Stan"
      }
      command.append("directory=\(directory)")

      if let model = options.model {
        modelName = model
      } else {
        modelName = "bernoulli"
      }
      command.append("model=\(modelName)")
      
      command.append(contentsOf: options.values)
      if options.verbose {
        print(command)
      }
    
      let result = optimize(directory: directory,
              model: modelName,
              cmdstan: cmdstan,
              verbose: options.verbose
      )
      print(result)
    }
  }
}

extension Stan {
  struct Pathfinder: ParsableCommand {
    static let configuration = CommandConfiguration(
      commandName: "pathfinder",
      abstract: "Use Pathfinder approximation.")

    // The `@OptionGroup` attribute includes the flags, options, and
    // arguments defined by another `ParsableArguments` type.
    @OptionGroup var options: Options
    
    mutating func run() {
      let environment = ProcessInfo.processInfo.environment
      let cmdstan: String
      let directory: String
      let modelName: String

      var command: [String] = [Stan.Pathfinder.configuration.commandName!]
      
      if options.verbose {
        command.append("verbose=\(options.verbose)")
      }
      
      if options.nocompile {
        command.append("nocompile=\(options.nocompile)")
      }
      
      if options.nosummary {
        command.append("nosummary=\(options.nosummary)")
      }
      
      if let cmdstanpath = options.cmdstan {
        cmdstan = cmdstanpath
      } else {
        if let path = environment["CMDSTAN"] {
          cmdstan = path
        } else {
          cmdstan = "/Users/rob/Projects/StanSupport/cmdstan"
        }
      }
      command.append("cmdstan=\(cmdstan)")

      if let dir = options.directory {
        directory = dir
      } else {
        directory = "Stan"
      }
      command.append("directory=\(directory)")

      if let model = options.model {
        modelName = model
      } else {
        modelName = "bernoulli"
      }
      command.append("model=\(modelName)")
      
      command.append(contentsOf: options.values)
      if options.verbose {
        print(command)
      }
      
      let _ = pathfinder(directory: directory,
              model: modelName,
              arguments: options.values,
              cmdstan: cmdstan,
              verbose: options.verbose
      )
    }
  }
}

extension Stan {
  struct Stansummary: ParsableCommand {
    static let configuration = CommandConfiguration(
      commandName: "stansummary",
      abstract: "Run the Stan summary program.")

    // The `@OptionGroup` attribute includes the flags, options, and
    // arguments defined by another `ParsableArguments` type.
    @OptionGroup var options: Options
    
    mutating func run() {
      let environment = ProcessInfo.processInfo.environment
      let cmdstan: String
      let directory: String
      let modelName: String

      var command: [String] = [Stan.Stansummary.configuration.commandName!]
      
      if options.verbose {
        command.append("verbose=\(options.verbose)")
      }
      
      if let cmdstanpath = options.cmdstan {
        cmdstan = cmdstanpath
      } else {
        if let path = environment["CMDSTAN"] {
          //print(path)
          cmdstan = path
        } else {
          cmdstan = "/Users/rob/Projects/StanSupport/cmdstan"
        }
      }
      command.append("cmdstan=\(cmdstan)")

      if let dir = options.directory {
        directory = dir
      } else {
        directory = "Stan"
      }
      command.append("directory=\(directory)")

      if let model = options.model {
        modelName = model
      } else {
        modelName = "bernoulli"
      }
      command.append("model=\(modelName)")
      
      command.append(contentsOf: options.values)
      print(command)
      
      let _ = stansummary(directory: directory,
              model: modelName,
              cmdstan: cmdstan
      )
    }
  }
}
