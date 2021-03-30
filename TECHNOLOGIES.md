Create Technologies.md

- List out what technologies the project uses and why we made the decisions we did. Mention the tradeoffs. 

- Mention failure scenarios here and how we will avoid them or how disaster recovery works.

- Create a section of the document: Security & Privacy. Edit to include an assessment of how you'd benchmark and audit the security health of the application at various points in user experience. 

# Technologies

## What Technologies Did We Choose?

### Stack:
- Front-End: 
    - End State: TBD
    - Current State: Vanilla JS (hoping for short-term Material UI redo before demo)

- API Gateway?

- Web API Layer:
    - End State:
    - Current State: Phoenix web framework
        - POST: organ_intake_request -> tracking_number & metadata

- Backend Services:
    - End State:
    - Current State: 
        - Matching CLI: OCaml Rule Engine
        - Scheduling CLI & Backend Service?: OCaml Rule Engine?
            - POST: organ_intake_information -> redis()

- Cache: 
    - End State: Redis
    - Current State: Redis
        - POST: organ_intake_information -> ()

- Long Term Storage: 
    - End State: Postgresql
    - Current State: Postgresql


### Tradeoffs

### Architecture Diagram

## Failure Scenarios & Disaster Recovery

## Privacy & Security Considerations