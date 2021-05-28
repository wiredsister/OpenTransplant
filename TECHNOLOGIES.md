# Technologies

## What Technologies Did We Choose?

### Stack:

- Front-End: 
    - End State: [TODO]
    - Current State: Vanilla JS (hoping for short-term Material UI redo before demo)

- API Gateway?
  - Something like stateful Kong? [TODO]

- Web API Layer:
    - End State: _Probably Phoenix_ [TODO]
    - Current State: Phoenix web framework
        - POST: organ_intake_request -> tracking_number & metadata

- Backend Services:
    - End State: _Probably OCaml CLI_ [TODO]
    - Current State: 
        - Matching CLI: OCaml Rule Engine
        - Scheduling CLI & Backend Service?: OCaml Rule Engine? [TODO]
- Cache: 
    - End State: _Probably Redis_ [TODO]
    - Current State: Redis
        - POST: organ_intake_information -> ()

- Long Term Storage: 
    - End State: _Probably Postgresql_ [TODO]
    - Current State: [TODO]

### Tradeoffs:

OCaml Pros:
- Formal Verification 
- Modularity (Module Namespacing, OpenTransplant Library versioned separate)
- Strongly Typed
- High-level with easy to read interfaces (clinicians and policy people will appreciate that)

### Architecture Diagram:

[TODO]

## Failure Scenarios & Disaster Recovery:

[TODO]

## Privacy & Security Considerations:

[TODO]