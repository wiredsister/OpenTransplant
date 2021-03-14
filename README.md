
# OpenTransplant

## Democratized Organ Procurement Transplant Network For The People

### Project Status: 

Reference implementation only; not intended for use in any pilot or production scenario.

### Maintainer
https://github.com/wiredsister

### Authors
https://github.com/yanlow, https://github.com/wiredsister

### Project Ethos

We believe every country and community, regardless of wealth or ability, should be able to operate an organ transplant network for its citizens. We believe this organ transplant network should be safe, auditable, free of fraud, waste, and abuse; we believe this system should benefit life and reduce death. 

<< TODO: @meredithstewart needs to add some edits >>

### Key Features & Road Map:
- organ decay is reduced
- patient outcomes are optimized for
- underserved populations and communities of color are measured against population for equity (TODO: think about how we can convey importance of data analytics and preventatitve warnings to policy makers)
- the system can measure end to end actions and the implications of policy changes quickly and easily
- the system should be near real-time with zero downtime
- the system should not require paper or human intervention
- the system will be modern and incorporate medical research (HLA crossmatching, organ sizing innovations, modern logistics & tracking)

### Sources & Thanks

This entire application was designed and built using publically available information from OPTN, UNOs, and HRSA found via Google as well as numerous medical papers from scholarly journals. See PAPERS.md (TODO: must add citations & PAPER.md file for medical lit.) for details.

### Architecture Diagram

![Image of Tentative Organ Transplant Architecture](https://user-images.githubusercontent.com/3818802/103159093-38953800-4793-11eb-87c7-090c816c9cc9.jpg)

- Web API Layer: Elixir Phoenix Web API Stack
- FrontEnd: Node.js, SCSS styling
- Backend Matching & Scheduling: OCaml services

### Tech Road Map

1. Webapp for OPOs
2. Webapp for Patient
3. EHR FHIR API integration for EPIC & Cerner
4. Gherkin & Cucumber Scenario tests for each organ & user health

### Supported Organ Donation & Donor Types Out of Box: 

```ocaml

type donortype = 
    | LivingDonor of Human.t * Policy.living_donor_requirements
    | RegularDonor of Human.t
    | NearDeathDonor of Human.t

type organ_transplant_type =
    (* Grafting *)
    | HeartGraft of donortype Organ.t
    | KidneyGraft of donortype Organ.t
    | LungGraft of donortype Organ.t
    | LiverGraft of donortype Organ.t
    | IntestinesGraft of donortype Organ.t
    | PancreasGraft of donortype Organ.t
    | BoneMarrowGraft of donortype Organ.t
    | Grafts of organ_transplant_type list

    (* Whole Organ Transplants *)
    | HeartTransplant of donortype Organ.t
    | PancreasTransplant of donortype Organ.t
    | LiverTransplant of donortype Organ.t 
    | IntestinesTransplant of donortype Organ.t
    | SingleKidneyTransplant of donortype Organ.t
    | DualKidneyTransplant of donortype Organ.t
    | BilateralLungTransplant of donortype Organ.t
    | SingleLungTransplant of donortype Organ.t
    | HeartAndLungsTransplant of donortype Organ.t * organ_transplant_type
    | ManyOrganTransplant of organ_transplant_type list

    (* Tissue Transplant *)
    | BoneMarrowTransplant of donortype Organ.t
    | TissueTransplant of donortype Organ.t
    | ManyTissueTransplants of donortype Organ.t list
    | TissueGraft of donortype Organ.t
    | ManyTissueGrafts of donortype Organ.t list

```

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
