#import "@preview/abbr:0.2.3"
=== Backend

*Technologies*

The backend was implemented in *Java*, a mature and type-safe language widely adopted in enterprise-grade applications due to its performance, robust tooling ecosystem, and long-term support. To accelerate development and reduce boilerplate code, we adopted the *Spring Boot* framework, which offers a convention-over-configuration paradigm and seamless integration with web, data, and security components.

Data persistence is handled by *PostgreSQL*, an open-source relational database known for its reliability, extensibility, and compatibility with spatial and time-series data, both of which are central to our application.

To enable model inference within the backend, we integrated the #abbr.a[DJL] @DJLDeepJava. DJL provides a high-level Java API for loading and running deep learning models, allowing seamless integration of our trained PyTorch models into the Spring Boot service. It also supports GPU acceleration via CUDA, significantly reducing inference latency on compatible hardware.


*Architecture*

We adopted the *Clean Architecture* pattern @martinCleanArchitectureCraftsmans2018 to ensure a modular, maintainable, and testable codebase. This architecture clearly separates domain logic from external concerns and enforces a unidirectional dependency rule: inner layers must not depend on outer ones.

The architecture is organized as follows:

- *Domain Layer*: Contains the core business entities and domain logic. It is fully decoupled from technical details and external frameworks. This is shown in the inner circle of @clean-architecture. 
- *Application Layer*: Defines use cases and orchestrates business rules by coordinating entities. It contains interfaces (ports) that declare what functionality is needed from the infrastructure.
- *Infrastructure Layer*: Implements the interfaces declared in the application layer, handling integration with external systems such as the *Deep Java Library* (for inference) and *PostgreSQL* (via Spring Data JPA).
- *Presentation Layer*: Exposes the application's functionality via RESTful APIs, using Spring MVC. It handles HTTP requests, authentication, and response formatting with Data Transfer Objects.

This separation of concerns enhances testability and makes it straightforward to substitute components (e.g., switch databases or machine learning backends) without affecting core logic.



#figure(image("images/clean_architecture.png"),
caption: [Illustration of the applied Clean Architecture of the Backend]
)<clean-architecture>


#figure(
  image("images/backend_application.png", width: 87%),
  caption: [
    Class Diagram for Application Layer of Backend
  ],
)

*Test Concept*

All technically relevant logic components (e.g., services, handlers, business logic classes) are covered by unit tests. These tests verify the behavior of each class in isolation from external dependencies by using mocks or stubs. The goal is to achieve high test coverage of the core logic and to ensure the correct handling of inputs, states, and error scenarios.





=== Frontend

#figure(
  image("images/Stormmind_Deployment.png", width: 110%),
  caption: [
    web routing: created with
    apple freeform, laptop from chatgpt
    (prompt: "erstelle mir ein png eines minimalistischen
    laptops ohne hintergrund")

  ],
)

*Technologies*

The Frontend consists of a react/vite repository. The DNS Entree was made on Hosttech and references an instance on the Openstack cluster of ZHAW @LoginOpenStackDashboard

*Test Concept*

Given the small scope of the frontend, automated testing was not conducted. Functional correctness was instead ensured through manual testing during development.


=== CI/CD and Deployment