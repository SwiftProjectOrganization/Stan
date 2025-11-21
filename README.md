# Stan

| **Project Status**          |
|:---------------------------:|
|![][project-status-img] |

[project-status-img]: https://img.shields.io/badge/lifecycle-experimental-orange.svg
[CI]:https://github.com/StanJulia/StanIO.jl/actions/workflows/CI.yml/badge.svg

## Purpose

A Swift/MacOS 26 based CLI to run Stan programs using Stan's cmdstan executable.

This is still very preliminary!!!! I can see a million improvements, but I needed to be able to run Stan models to use in an accompanying project [SwiftStats](https://github.com/SwiftProjectOrganization/SwiftStats) (also work in progress!).

## Details

Currently the initial set of cmdstan methods supported is:

1. Compile a Stan model file
2. Sample from a compiled Stan model and extract the samples in a clean *model*.samples.csv file.
3. Run stansummary on the 4 output files created during sampling and create a clean *model*.stansummary.csv file
4. Run Stan's optimize option and collect the results in a clean *model*.optimize.csv file
5. Run Stan's pathfinder method

## Setup

This repository is an Xcode project. It expects an environment variable "CMDSTAN" to point to the cmdstan directory. See [cmdstan](https://mc-stan.org/docs/2_37/cmdstan-guide/).

By default it expects all Stan models and input data json files to be in a subdirectory of your "~/Documents" directory.

Below usage examples follows the Bernoulli example in the cmdstan folder. For this to work out of the box, have in your "~/Documents" directory a subdirectory "Stan" containing a copy of the "bernoulli.data.json" file from the cmdstan installation folder.

If you want to run the CLI from a shell, the shell needs to be able to run "./stan". The way I do this is to copy the "stan" binary from your Xcode build directory to the "~/Documents/Stan" directory.

That "stan" binary can be found in finder:

1. Click on "Library" in your home folder.
2. Click on "Developer"
3. Click on "Xcode/DerivedData"
4. Click on "Stan_..............."
5. Click on "Build"
6. Click on "Products"
7. Click on "Debug" ... and there is the stan binary!


## Usage

rob@Rob-Travel-M5 Stan % ./stan -h
OVERVIEW: A wrapper for running cmdstan.

USAGE: ./stan <subcommand>

OPTIONS:
  --version               Show the version
  -h, --help              Show help information

SUBCOMMANDS:

  compile                 Compile the Stan model
  sample (default)        Sample the Stan model
  optimize                Optimize the Stan model
  pathfinder              Pathfinder approximation
  stansummary             Run the stansummary program
  
  See 'stan help <subcommand>' for detailed help.


rob@Rob-Travel-M5 Stan % ./stan compile

("Stan model file has not changed, no compilation needed.", "")


rob@Rob-Travel-M5 Stan % ./stan compile -V --directory Stan/Test

["compile", "cmdstan=/Users/rob/Projects/StanSupport/cmdstan/", "directory=Stan/Test", "model=bernoulli"]
Given directory file:///Users/rob/Documents/Stan/Test/bernoulli does not exist.
Created directory file:///Users/rob/Documents/Stan/Test/bernoulli 
New Stan model file created.
Compiling...
("Command `/usr/bin/make (bernoulli executable)` completed successfully.", "")


rob@Rob-Travel-M5 Stan % ./stan sample -h

OVERVIEW: Sample the Stan model.

USAGE: stan sample [--verbose] [--nocompile] [--nosummary] [--cmdstan <cmdstan>] [--directory <directory>] [--model <model>] [<values> ...]

ARGUMENTS:
  <values>                Arguments for method.

OPTIONS:
  -V, --verbose           Show more information.
  -C, --nocompile         Don't compile the model before sampling.
  -S, --nosummary         Don't run stansummary.
  --cmdstan <cmdstan>     Location of cmdstan.
  --directory <directory> Directory path.
  --model <model>         Model name.
  --version               Show the version.
  -h, --help              Show help information.


rob@Rob-Travel-M5 Stan % ./stan sample -V

["sample", "verbose=true", "cmdstan=/Users/rob/Projects/StanSupport/cmdstan/", "directory=Stan", "model=bernoulli"]
("Command `/usr/bin/make (bernoulli executable)` completed successfully.", "")
("Command `/Users/rob/Documents/Stan/bernoulli/bernoulli sample` completed successfully.", "")
("CSV file created at: /Users/rob/Documents/Stan/bernoulli/bernoulli_samples.csv.", "")
("Command `/Users/rob/Projects/StanSupport/cmdstan//bin/stansummary` completed successfully.", "")
("CSV file created at: /Users/rob/Documents/Stan/bernoulli/bernoulli_stansummary.csv.", "")


## References

1. [Stan](https://mc-stan.org/docs/2_37/cmdstan-guide/)


