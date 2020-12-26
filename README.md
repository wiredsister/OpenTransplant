
# OpenTransplant

## Democratized Organ Procurement Transplant Network For The People

### Project Status: 

In Development! Not ready to be used in any pilot or production scenario.

### Maintainer 

### Project Ethos

### Sources & Thanks

#### RoadMap

1. Webapp for OPOs
2. Webapp for Patient
3. EHR FHIR API integration for EPIC & Cerner
4. Gherkin & Cucumber Scenario tests for each organ & user health

### Build & Run

### OCaml Environment

#### Windows Machine

1. Follow these instructions to get WSL for Debian: 
https://docs.microsoft.com/en-us/windows/wsl/install-win10
2. apt-get install ocaml
3. Proceed to Build step

#### Linux

1. apt-get install ocaml
2. Proceed to Build step

#### OSX

1. brew install ocaml
2. Proceed to Build step

### Visual Studio Code Setup

Packages Used:

- OCaml and Reason IDE (@ext:freebroccolo.reasonml)
- Remote - WSL  (@ext:ms-vscode-remote.remote-wsl)
- FiraCode (install _is not_ through VSCode store, but rather follow instructions here: https://github.com/tonsky/FiraCode >> and change font-family setting in **VSCode > Editor** to `"Fira-Code"`)

### Build

Go to root directory where `dune-project` is and run:

```
sh build.sh
sh start.sh
```

