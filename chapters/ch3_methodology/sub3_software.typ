#import "@preview/abbr:0.2.3"
=== Backend

*Technologies*

Java was selected as the backend language due to its reliability and long-standing maturity. To improve startup time and enable rapid development of functional components, the Spring Boot framework was used. Since the system depends on frequently updated weather data provided via an external API, a database was introduced to reduce the load on the API. PostgreSQL was chosen for its robustness and strong compatibility with standard SQL.

*Architecture*

*Test Concept*

All technically relevant logic components (e.g., services, handlers, business logic classes) are covered by unit tests. These tests verify the behavior of each class in isolation from external dependencies by using mocks or stubs. The goal is to achieve high test coverage of the core logic and to ensure the correct handling of inputs, states, and error scenarios.

*TODO*

#figure(
  image("images/stormmind_calss_diagramm.png", width: 87%),
  caption: [
    Class Diagramm: generated from JetBrains IntelliJ IDEA
  ],
)

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