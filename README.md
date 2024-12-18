# Siemens-Energy Monitoring Data

The solution uses Docker, Docker Compose, Kubernetes (minikube) and Helm Charts.

The deployment consists of three microservices: 

 - **producer**: An MVC application in Python that generates random sensor data.
 - **timescaledb**: A PostgreSQL database enhanced with TimescaleDB extensions for time series data.
 - **grafana**: A tool for data visualization.

# Docker

Install dependencies:

	$ ./siemens-energy/docker-compose/install/docker.sh

Run each microservice separately, go inside each directory (producer, timescaledb and grafana) and run the the `docker-run.sh`, for example, to producer:

    $ ./siemens-energy/docker-compose/producer/docker-run.sh

# Docker Compose

Navigate to the directory:

	$ cd ./siemens-energy/docker-compose/
    
Build all services:

	$ docker compose build

Run all services:

    $ docker compose up -d

Scale the producer service:

    $ docker compose up -d --scale producer=2

Stop the services:

    $ docker compose down -v

# Kubernetes and Helm Charts

Install Kubernetes (minikube):

    $ ./siemens-energy/helm-charts/install/k8s.sh

Install Helm Charts:

    $ ./siemens-energy/helm-charts/install/helm.sh

Start the Cluster:

    $ ./siemens-energy/helm-charts/install/start-cluster.sh

Build the images for the correct namespace:

    $ ./siemens-energy/helm-charts/images/build.sh

Navigate to the Helm Charts umbrella charts:

    $ cd ./siemens-energy/helm-charts/monitoring-stack

Deploy all services:

    $ helm install monitoring-stack . --namespace siemens-energy --create-namespace

Upgrade all services:

    $ helm upgrade monitoring-stack . --namespace siemens-energy --create-namespace

Uninstall all services:

    $ helm uninstall monitoring-stack --namespace siemens-energy

If any error occurs, check the templates:

    $ helm template monitoring-stack . --namespace siemens-energy --create-namespace

Scale the producer:

    $ kubectl scale -n siemens-energy sts producer --replicas=2

* producer-0 will read the sensors-0.yaml
* producer-1 will read the sensors-1.yaml
* producer-2 will read the sensors-3.yaml, and so on

Useful kubectl commands:

    $ kubectl get pods -n siemens-energy
    $ kubectl get services -n siemens-energy
    $ kubectl kubectl get all -n siemens-energy

To access the Grafana, get the External IP and Port to access via browser:

    $ kubectl get services -n siemens-energy grafana

* **username**: grafana
* **password**: monitoring

# Infrasctructure

```.
├── LICENSE
├── README.md
├── docker-compose
│   ├── docker-compose.yaml
│   ├── grafana
│   │   ├── Dockerfile
│   │   ├── docker-run.sh
│   │   └── provisioning
│   │       ├── dashboards
│   │       ├── dashboards_json
│   │       └── datasources
│   ├── install
│   │   └── docker.sh
│   ├── producer
│   │   ├── Dockerfile
│   │   ├── config
│   │   │   └── sensors-0.yaml
│   │   ├── controllers
│   │   │   └── producer.py
│   │   ├── docker-run.sh
│   │   ├── main.py
│   │   ├── models
│   │   │   └── sensor.py
│   │   └── views
│   │       └── logger.py
│   └── timescaledb
│       ├── Dockerfile
│       ├── check_databases.sh
│       ├── create_grafana_db.sql
│       ├── create_producer_db.sql
│       └── docker-run.sh
└── helm-charts
    ├── images
    │   └── build.sh
    ├── install
    │   ├── helm.sh
    │   ├── k8s.sh
    │   └── start-cluster.sh
    └── monitoring-stack
        ├── Chart.yaml
        ├── charts
        │   ├── grafana
        │   ├── producer
        │   └── timescaledb
        └── values.yaml
```