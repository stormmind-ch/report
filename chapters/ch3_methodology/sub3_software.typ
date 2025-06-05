#import "../../abbr-impl.typ"
#import "../../abbr.typ"
=== Backend

The backend was implemented in Java, a type-safe language. To accelerate development and reduce boilerplate code, we adopted the Spring Boot framework, which offers a convention-over-configuration paradigm and seamless integration with web, data, and security components.

Data persistence is handled by PostgreSQL, an open-source relational database.

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

- *Application Layer*: Defines the system's use cases and orchestrates business rules by coordinating entities. It is responsible for implementing application-specific logic while remaining independent of external technologies. This layer also defines interfaces, named _Ports_ that describe the required functionality from the infrastructure layer.

A central part of this layer is the inference orchestration logic, which involves multiple sequential steps. To manage this complexity, we adopted the Chain of Responsibility design pattern @ChainResponsibility. This allows each step in the inference process to be encapsulated in a dedicated handler that can pass the request along the chain. The chain is hold by the _ForecastService_ class, which is shown on the bottom left corner of @backend_application.

#figure(
  image("images/backend_application.png"),
  caption: [
    Class Diagram for Application Layer of the Backend
  ],
)<backend_application>
- *Infrastructure Layer*: The Infrastructure Layer provides concrete implementations of the interfaces (_Ports_) defined in the Application Layer. It is responsible for «integrating external systems and technologies, such as:
  - PostgreSQL, using Spring Data JPA for data persistence,
  - the Deep Java Library (DJL) for running deep learning model inference,
  - and Open-Meteo APIs for weather data retrieval.
  This layer encapsulates all technical details and external dependencies, keeping the rest of the system decoupled from implementation concerns.

  To support modular weather data retrieval, the Factory Pattern is employed in the _OpenMeteoWeatherFetcherFactory_. This allows dynamic instantiation of the appropriate _WeatherFetcher_ implementation based on the request context.

  In addition, the Decorator Pattern is used to compose weather fetchers with different temporal scopes:
  The base fetcher retrieves current-week data.
  It is then wrapped by decorators to add previous-month and previous-year data, respectively, forming a flexible and extensible weather data pipeline.

  Persistence adapters implement the required interfaces by delegating to Spring Data JPA repositories. These adapters act as bridges between the domain model and the database, handling entity retrieval and storage.

  The _ModelInferenceServiceFactory_ uses a simple factory mechanism to return the appropriate model-specific inference service (e.g., FNN, LSTM, Transformer) depending on the requested type.

  The most important infrastructure classes are illustrated in @backend_infrastructure

#figure(image("images/backend_infrastructure.png"), 
caption: [Class Diagram for Infrastructure Layer of the Backend ]
)<backend_infrastructure>

- *Presentation Layer*: Exposes the application's functionality to external clients via RESTful HTTP APIs, implemented using Spring MVC. It is responsible for handling incoming HTTP requests, delegating execution to the appropriate application services or adapters, and formatting responses using Data Transfer Objects (DTOs).
  
  Each controller corresponds to a specific use case or domain concept:

  - _DamageController_ manages endpoints for recording and retrieving individual damage events.
  - _GroupedDamageController_ provides access to aggregated damage data grouped by municipality.
  - _ForecastController_ serves endpoints for requesting deep learning model forecasts, either for all municipalities or a specific one.

This separation of concerns enhances testability and makes it straightforward to substitute components (e.g., switch databases) without affecting core logic.

*Caching:*

After the initial deployment, user tests were conducted as outlined in the frontend test concept chapter. During these tests, a noticeable and user-unfriendly delay was observed. The issue was traced back to the request responsible for retrieving forecast data for all municipalities in Switzerland, which depends on the open-meteo API @zippenfenigOpenMeteocomWeatherAPI2023. Since this request must aggregate weather data across a large number of locations, it involves considerable processing time.

To better assess the performance characteristics of this request, response times were measured and compared under different conditions. The following tables present both the individual request durations and the corresponding average values across varying caching and deployment scenarios.
// (0.02+0.019+0.016+0.012+0.019+0.014+0.017+0.016+0.014)/9 = 
// 0.0163333

// (55.34+52.75+52.39+49.41+49.74+54.50+52.75+54.00+52.01+51.46)/10 = 
// 52.112222222

// (0.133+0.057+0.052+0.056+0.035+0.034+0.076+0.043+0.044+0.035)/10 =
// 0.048

#figure(table(
  columns: 4,

  table.header( [*request \#*], [*local cached*],[*local uncached*], [*production cached*]),
   align: center,
  [*1*], [54.69 s],[55.34 s],[133 ms],
  [*2*],[20 ms],[52.75 s],[57 ms],
  [*3*],[19 ms],[52.39 s],[52 ms],
  [*4*],[16 ms],[49.41 s],[56 ms],
  [*5*],[12 ms],[49.74 s],[35 ms],
  [*6*],[19 ms],[54.50 s],[34 ms],
  [*7*],[14 ms],[52.75 s],[76 ms],
  [*8*],[17 ms],[54.00 s],[43 ms],
  [*9*],[16 ms],[52.01 s],[44 ms],
  [*10*],[14 ms],[51.46 s],[35 ms],
),
caption: [Comparison of forecast retrieval times for all municipalities: locally with caching, locally without caching, and via the production API with caching.\
*Note:* For caching scenarios, the initial request populates the cache and thus exhibits similar latency to uncached retrieval. The cache is valid for 24 hours. In the case of the production system, the initial daily request had already been completed, resulting in no noticeable difference between the first and subsequent requests.]
)<caching-times-test>
#pagebreak()
#figure(table(
  columns: 4,

  table.header( [*averages*], [*local cached*],[*local uncached*], [*production cached*]),
   align: center,
  [*ø*], [$16.#math.overline("3")$ ms],[$52'112.#math.overline("2")$ ms],[48 ms],
),
caption: [Average request times\
*Note:* To account for cache warm-up, only requests two to ten were included in the calculation of the average request time.]
)<caching-times-averages>

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

*Test Concept* <fft>

Given the small scope of the frontend, automated testing was not conducted. Functional correctness was instead ensured through manual testing during development.


=== CI/CD and Deployment

Deployment is managed via a virtual instance hosted on the *OpenStack* cluster of the ZHAW @LoginOpenStackDashboard. DNS configuration was performed using *Hosttech*, directing traffic to the appropriate backend infrastructure.

The application consists of two components: a backend and a frontend. Both are containerized using Docker and deployed with Kubernetes. The use of Kubernetes enables dynamic scalability, allowing the application to adapt to changing resource demands.

The frontend runs on port 80 within its pod and communicates over TCP. To manage and route incoming traffic, *Traefik* is used as an ingress controller. It is configured to forward requests to _stormmind.ch_, including the root path _/_ and all subpaths, to the frontend pod. Requests to _api.stormmind.ch_ are routed to the backend service, which listens on port 8080. All HTTP traffic is automatically redirected to HTTPS to ensure secure communication.

Both the backend and frontend deployments are configured to always pull the latest Docker image and to retain only one previous ReplicaSet. This setup simplifies the deployment process and reduces potential ambiguity when identifying the active version.

To enable HTTPS functionality, a _ClusterIssuer_ and a _Certificate_ resource were configured within the Kubernetes cluster. These components automatically request and manage TLS certificates from *Let's Encrypt*, making them available to Traefik for encrypted traffic handling.

For continuous integration and deployment, two separate GitHub Actions pipelines were implemented—one for the frontend and one for the backend. Both workflows are triggered on each push to the _main_ branch. The pipelines establish an SSH connection to the machine running the Kubernetes cluster, pull the latest project state, build new Docker images, push them to Docker Hub, and trigger a rollout of the updated containers.

Given the moderate size of the project, this CI/CD approach was deliberately chosen over the integration of additional DevOps tools in order to keep operational overhead low.

*Argo CD* is used to monitor the state of the Kubernetes cluster and manage application deployments, including version control and scaling.