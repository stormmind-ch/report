#import "@preview/abbr:0.2.3"
=== Backend

*Technologies*

BEcause of its reliability and years of improvement as the base of the backend, java was chosen. To imporve the startup time and quickly create functioning code, springboot was the chosen framework. its dependency on new weather data provided through an API arrose the need for a database to relieve the API. ostgreSQL was chosen for its reliability and strong compatibility with standard SQL.

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

The Frontend consists of a react/vite repository. The DNS Entree was made on Hosttech and references an instance on the Openstack cluster of ZHAW @LoginOpenStackDashboard

*Test Concept*

Given the small scope of the frontend, automated testing was not conducted. Functional correctness was instead ensured through manual testing during development.


=== CI/CD and Deployment