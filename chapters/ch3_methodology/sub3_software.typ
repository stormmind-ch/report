#import "@preview/abbr:0.2.3"
=== Backend

*Technologies*

The backend was implemented in Java, a mature and type-safe language widely adopted in enterprise-grade applications due to its performance, robust tooling ecosystem, and long-term support. To accelerate development and reduce boilerplate code, we adopted the Spring Boot framework, which offers a convention-over-configuration paradigm and seamless integration with web, data, and security components.

Data persistence is handled by PostgreSQL, an open-source relational database known for its reliability, extensibility, and compatibility with spatial and time-series data, both of which are central to our application.

To enable model inference within the backend, we integrated the #abbr.a[DJL] @DJLDeepJava. DJL provides a high-level Java API for loading and running deep learning models, allowing seamless integration of our trained PyTorch models into the Spring Boot service. It also supports GPU acceleration via CUDA, significantly reducing inference latency on compatible hardware.

*Architecture*

We adopted the Clean Architecture pattern @martinCleanArchitectureCraftsmans2018, visualized in @clean-architecture to ensure a modular, maintainable, and testable codebase. This architecture clearly separates domain logic from external concerns and enforces a unidirectional dependency rule: inner layers must not depend on outer ones.
#figure(image("images/clean_architecture.png"),
caption: [Illustration of the applied Clean Architecture of the Backend]
)<clean-architecture>

The architecture is organized as follows:

- *Domain Layer*: Encapsulates the core business entities and domain logic. It is entirely decoupled from technical concerns and external frameworks, as illustrated by the inner circle of the @clean-architecture. The following core entities have been defined:
    - Municipality: Represents a geographic administrative unit.
    - MunicipalityToCluster: Maps each municipality to its corresponding cluster, based on the chosen number of clusters $k$.
    - Damage: Represents a damage event recorded in the #abbr.a[WSL] database. It is also persisted in our PostgreSQL database.
    - GroupedDamage: Aggregated damage records grouped by municipality. This entity is materialized as a view in the PostgreSQL database.
    - Inference:  Encapsulates the input data required for making predictions using the deep learning models.
    - Forecaset: Represents the output produced by a deep learning model.
    - WeatherData: eteorological data required for performing inference with the deep learning models.

- *Application Layer*: Defines the system's use cases and orchestrates business rules by coordinating entities. It is responsible for implementing application-specific logic while remaining independent of external technologies. This layer also defines interfaces, named `Ports` that describe the required functionality from the infrastructure layer.

A central part of this layer is the inference orchestration logic, which involves multiple sequential steps. To manage this complexity, we adopted the Chain of Responsibility design pattern @ChainResponsibility. This allows each step in the inference process to be encapsulated in a dedicated handler that can pass the request along the chain. The chain is hold by the `ForecastService` class, which is shown on the bottom left corner of @backend_application.

#figure(
  image("images/backend_application.png", width: 50%),
  caption: [
    Class Diagram for Application Layer of the Backend
  ],
)<backend_application>
- *Infrastructure Layer*: The Infrastructure Layer provides concrete implementations of the interfaces (`Ports`) defined in the Application Layer. It is responsible for integrating external systems and technologies, such as:

- PostgreSQL, using Spring Data JPA for data persistence,
- the Deep Java Library (DJL) for running deep learning model inference,
- and Open-Meteo APIs for weather data retrieval.
This layer encapsulates all technical details and external dependencies, keeping the rest of the system decoupled from implementation concerns.

To support modular weather data retrieval, the Factory Pattern is employed in the `OpenMeteoWeatherFetcherFactory`. This allows dynamic instantiation of the appropriate `WeatherFetcher` implementation based on the request context.

In addition, the Decorator Pattern is used to compose weather fetchers with different temporal scopes:
The base fetcher retrieves current-week data.
It is then wrapped by decorators to add previous-month and previous-year data, respectively, forming a flexible and extensible weather data pipeline.

Persistence adapters implement the required interfaces by delegating to Spring Data JPA repositories. These adapters act as bridges between the domain model and the database, handling entity retrieval and storage.

The `ModelInferenceServiceFactory` uses a simple factory mechanism to return the appropriate model-specific inference service (e.g., FNN, LSTM, Transformer) depending on the requested type.

The most important infrastructure classes are illustrated in @backend_infrastructure

#figure(image("images/backend_infrastructure.png"), 
caption: [Class Diagram for Infrastructure Layer of the Backend ]
)<backend_infrastructure>

- *Presentation Layer*: The Presentation Layer exposes the application's functionality to external clients via RESTful HTTP APIs, implemented using Spring MVC. It is responsible for handling incoming HTTP requests, delegating execution to the appropriate application services or adapters, and formatting responses using Data Transfer Objects (DTOs).

Each controller corresponds to a specific use case or domain concept:

- `DamageController` manages endpoints for recording and retrieving individual damage events.
- `GroupedDamageController` provides access to aggregated damage data grouped by municipality.
`ForecastController` serves endpoints for requesting deep learning model forecasts, either for all municipalities or a specific one.

This separation of concerns enhances testability and makes it straightforward to substitute components (e.g., switch databases) without affecting core logic.

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

The frontend of the application is implemented using *React* and structured as a separate repository based on the *Vite* build tool. It follows a modular and maintainable architecture, distinguishing clearly between application logic and user interface components.

Routing is handled on the client side, and the overall structure aligns with modern single-page application principles. The development setup emphasizes performance, scalability, and a clear separation of concerns.

*Test Concept*

Given the small scope of the frontend, automated testing was not conducted. Functional correctness was instead ensured through manual testing during development.


=== CI/CD and Deployment

Deployment is managed via an instance hosted on the *OpenStack* cluster of ZHAW @LoginOpenStackDashboard, accessible through the *OpenStack Dashboard*. DNS configuration was carried out using *Hosttech*, pointing to the appropriate backend infrastructure.