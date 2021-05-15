
# OpenTransplant 

## Democratized Organ Procurement Transplant Network For The People

### Project Status: 

Reference implementation only; not intended for use in any pilot or production scenario.

[Open Source Project Kanban View](https://github.com/wiredsister/OpenTransplant/projects/1)

### Maintainer
[@wiredsister](https://github.com/wiredsister), Government Professional Account: [@ginabeena](https://github.com/ginabeena)

### Authors

- Devops & Backend: [@yanlow](https://github.com/yanlow) 
- Algorithms & Backend: [@wiredsister](https://github.com/wiredsister)
- Product: [@MeredithStewart](https://github.com/MeredithStewart)

Special thanks to: [@ns222](https://github.com/ns222)

### Project Ethos

We believe every country and community, regardless of wealth or ability, should be able to operate an organ transplant network for its citizens. We believe this organ transplant network should be safe, auditable, free of fraud, waste, and abuse; we believe this system should benefit life and reduce death. 

While this system will only ever exist as a reference implementation for United States policy, it will feature experimental algorithms to test alongside core functionality covered under public policy of the OPTN. Based upon statute the only organization in the United States that can run the Organ Network is UNOS, so this project remains hypothetical until further notice. 

### Key Features & Road Map:
- organ decay is reduced
- patient outcomes are optimized for
- underserved populations and communities of color are measured against population for equity
- the system can measure end to end actions and the implications of policy changes quickly and easily
- the system should be near real-time with zero downtime (equivalent to a 911 system or telecom)
- the system should not require paper or human intervention for the majority of process
- the system will be modern and incorporate medical research (HLA crossmatching, organ sizing innovations, modern logistics & tracking)
- the system will have a modern user interface and user experience which incorporates the human perspectives of surgeons, patients, organ procurement organizations, and transplant coordinators
- the algorithms are versioned and tested via CI/CD
- the system integrates with tools surgeons and coordinators already use
- the system incorporates scheduling and waitlist management seamlessly and orthoganlly to the matching logic
- the system provides a cold storage for patient outcomes to be updated and long term analysis
- the system will have an easy HIPAA compliant communication solution centered around an organ

### Sources & Thanks

This entire application was designed and built using publically available information from OPTN, UNOs, and HRSA found via Google as well as numerous medical papers from scholarly journals.

### User Journey Diagram

![Image of Idealized User Flow in Reference Prototype](https://user-images.githubusercontent.com/3818802/118364158-44786f80-b565-11eb-9b10-3f56e79d6d92.png)

- Web API Layer: Elixir Phoenix Web API Stack
- FrontEnd: JavaScript, CSS (Note: the UI is trash and will soon be replaced. We are looking for a designer & front-end expert if anybody has cycles)
- Backend Matching & Scheduling: OCaml services

### Tech Road Map

1. Webapp for Organ Tracking
2. Webapp for Organ Referral
3. Webapp for Patient account creation
4. Webapp for Surgeon Organ Offer
6. EHR FHIR API integration for [EPIC](https://www.epic.com/epic/post/one-kidney-donation-five-lives-saved) Phoenix (there Organ Transplant module) & [Cerner](https://www.cerner.com/)
7. Gherkin & Cucumber Scenario tests for each organ & user health

### Out of Box Functionality: 

Currently, the code base combines a lot of novel ideas, but these will soon be refactored into an experimental (Living Donors being combined with Deceased Donors donations, etc) module inside of Policy. There is also experimental support for tissue types beyond OPTN policy reference, but out of box support will not include these. This implementation is merely a possibile reference implenetation for public OPTN algorithms for waitlist and matching. 

## Build & Run

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
- Docker - (https://docs.docker.com/docker-for-windows/wsl/) to install 

### Build

Go to root directory where `dune-project` is and run:

```
sh build.sh
sh start.sh
```

### Clone Image

```
docker login
docker pull wiredsis/opentransplant:latest
```
Source: https://hub.docker.com/repository/docker/wiredsis/opentransplant/tags?page=1&ordering=last_updated

## Deployment

Local development
```
docker-compose -f docker/docker-compose.yml -f docker/docker-compose.dev.yml build
docker-compose -f docker/docker-compose.yml -f docker/docker-compose.dev.yml up -d
docker exec -it <container_id> /bin/bash
```
Staging
```
docker-compose -f docker/docker-compose.yml -f docker/docker-compose.prod.yml -f docker/docker-compose.staging.yml build
docker-compose -f docker/docker-compose.yml -f docker/docker-compose.prod.yml -f docker/docker-compose.staging.yml up -d
```
Production
```
docker-compose -f docker/docker-compose.yml -f docker/docker-compose.prod.yml build
docker-compose -f docker/docker-compose.yml -f docker/docker-compose.prod.yml up -d
```
