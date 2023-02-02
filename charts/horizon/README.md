# Helm Chart for Horizon

## Introduction

This Helm chart installs [Horizon](https://github.com/horizoncd/horizon) in a Kubernetes cluster. 

## TL;DR

```console
helm repo add horizon https://horizoncd.github.io/helm-charts
helm install horizon horizon/horizon -n horizoncd
```

**Attention:**

- The chart's default `values.yaml` file provides a minimal installation, only for test purpose, not for production
  use.

## Prerequisites

- Kubernetes cluster 1.19+
- Helm 3.4.0+

## Installation

### Add Helm repository

```bash
helm repo add horizon https://horizon.github.io/helm-charts
```

### Install the chart

Install the Horizon helm chart with a release name `horizon` in `horizoncd` namespace:

helm 3:

```bash
helm install horizon horizon/horizon -n horizoncd
```

### Uninstallation

To uninstall the `horizon` release:

helm 3:

```bash
helm uninstall horizon -n horizoncd
```

## Parameters

### Common parameters

| Name               | Description                                    | Value |
| ------------------ | ---------------------------------------------- | ----- |
| `nameOverride`     | String to partially override fullname template | ""    |
| `fullnameOverride` | String to fully override fullname template     | ""    |
| `imagePullSecrets` | The image pull policy                          | ""    |
| `imagePullPolicy`  | The imagePullSecrets names for all deployments | ""    |

### Ingress parameters

| Name              | Description             | Value              |
| ----------------- | ----------------------- | ------------------ |
| `ingress.enabled` | The replica count       | true               |
| `ingress.tls`     | Tls for ingress's hosts | []                 |
| `ingress.hosts`   | Hosts for the ingress   | - horizon.h8s.site |

### Core / Job application parameters

| Name                                                   | Description                                                                                                                                                     | Value                                                                                                                                                                                                                                                                                                                                           |
| ------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `config.serverConfig.port`                             | The service port Horizon listens on when serving with HTTP                                                                                                      | 8080                                                                                                                                                                                                                                                                                                                                            |
| `config.cloudEventServerConfig.port`                   | The service port CloudEvent listens on when serving with HTTP. CloudEvent is a a separate HTTP service used to receive callback requests from Tekton.           | 8181                                                                                                                                                                                                                                                                                                                                            |
| `config.dbConfig.host`                                 | The host of the database                                                                                                                                        | horizon-mysql                                                                                                                                                                                                                                                                                                                                   |
| `config.dbConfig.port`                                 | The port of the database                                                                                                                                        | 3306                                                                                                                                                                                                                                                                                                                                            |
| `config.dbConfig.username`                             | The username of the database                                                                                                                                    | horizon                                                                                                                                                                                                                                                                                                                                         |
| `config.dbConfig.password`                             | The password of the database                                                                                                                                    | horizon                                                                                                                                                                                                                                                                                                                                         |
| `config.dbConfig.database`                             | The schema of the database                                                                                                                                      | horizon                                                                                                                                                                                                                                                                                                                                         |
| `config.dbConfig.prometheusEnabled`                    | Enable prometheus metrics exposing or not                                                                                                                       | true                                                                                                                                                                                                                                                                                                                                            |
| `config.kubeconfig`                                    | The kubeconfig Horizon use                                                                                                                                      | ""                                                                                                                                                                                                                                                                                                                                              |
| `config.redisConfig.protocol`                          | The protocol of the redis Horizon will connect                                                                                                                  | tcp                                                                                                                                                                                                                                                                                                                                             |
| `config.redisConfig.address`                           | The address of the redis Horizon will connect                                                                                                                   | horizon-redis-ha:6379                                                                                                                                                                                                                                                                                                                           |
| `config.redisConfig.password`                          | The password of the redis Horizon will connect                                                                                                                  | ""                                                                                                                                                                                                                                                                                                                                              |
| `config.redisConfig.db`                                | The database of the redis Horizon will connect                                                                                                                  | 1                                                                                                                                                                                                                                                                                                                                               |
| `config.sessionConfig.maxAge`                          | The duration of the session                                                                                                                                     | 43200                                                                                                                                                                                                                                                                                                                                           |
| `config.gitRepos`                                      | The git repository configurations, including url and token, example is like:<br/>gitRepos:<br/>- kind: github<br/>  url: https://github.com<br/>  token: xxxxxx | []                                                                                                                                                                                                                                                                                                                                              |
| `config.gitopsRepoConfig.rootGroupPath`                | The path of the root group for gitops gitlab                                                                                                                    | cloud-native                                                                                                                                                                                                                                                                                                                                    |
| `config.templateRepo.kind`                             | The kind of the repository for templates, `harbor` and `chartmuseum` are the available options                                                                  | chartmuseum                                                                                                                                                                                                                                                                                                                                     |
| `config.templateRepo.host`                             | The host of the repository for templates                                                                                                                        | http://horizon-chartmuseum:8080                                                                                                                                                                                                                                                                                                                 |
| `config.templateRepo.username`                         | The username of the repository the templates                                                                                                                    | ""                                                                                                                                                                                                                                                                                                                                              |
| `config.templateRepo.password`                         | The password of the repository for templates                                                                                                                    | ""                                                                                                                                                                                                                                                                                                                                              |
| `config.templateRepo.insecure`                         | Set security of the host of the repository for templates                                                                                                        | true                                                                                                                                                                                                                                                                                                                                            |
| `config.templateRepo.repoName`                         | Project name in the Chart Repository (must be set when kind is `harbor`)                                                                                        | ""                                                                                                                                                                                                                                                                                                                                              |
| `config.argoCDMapper`                                  | The mapping between environments and configs of argocds                                                                                                         | default:<br/>  url: http://horizon-argocd-server<br/>  token: xxx<br/>  namespace: horizoncd                                                                                                                                                                                                                                                    |
| `config.tektonMapper`                                  | The mapping between environments and configs of tektons                                                                                                         | default:<br/>  server: http://el-horizon-  listener:8080<br/>  namespace: horizoncd<br/>  kubeconfig: ""<br/>  s3:<br/>    accessKey: admin<br/>    secretKey: qOIh3Xt5jg<br/>    region: china<br/>    endpoint: "horizon-minio:9000"<br/>    bucket: horizon<br/>    disableSSL: true<br/>    skipVerify: true<br/>    s3ForcePathStyle: true |
| `config.grafanaConfig.host`                            | The host of the grafana installed on the K8s                                                                                                                    | ""                                                                                                                                                                                                                                                                                                                                              |
| `config.grafanaConfig.namespace`                       | The namespace of the grafana installed on the K8s                                                                                                               | horizoncd                                                                                                                                                                                                                                                                                                                                       |
| `config.grafanaConfig.dashboards.labelKey`             | The dashboards' label key of the grafana installed on the K8s                                                                                                   | grafana_dashboard                                                                                                                                                                                                                                                                                                                               |
| `config.grafanaConfig.dashboards.labelValue`           | The dashboards' label value of the grafana installed on the K8s                                                                                                 | "1"                                                                                                                                                                                                                                                                                                                                             |
| `config.grafanaConfig.syncDatasourceConfig.period`     | The period that horizon-job sync prometheus datasources to grafana                                                                                              | 2m                                                                                                                                                                                                                                                                                                                                              |
| `config.grafanaConfig.syncDatasourceConfig.labelKey`   | The datasources' label key of the grafana installed on the K8s                                                                                                  | grafana_datasource                                                                                                                                                                                                                                                                                                                              |
| `config.grafanaConfig.syncDatasourceConfig.labelValue` | The datasources' label value of the grafana installed on the K8s                                                                                                | "1"                                                                                                                                                                                                                                                                                                                                             |
| `config.autoFree.enabled`                              | Enable autoFree moudule or not                                                                                                                                  | false                                                                                                                                                                                                                                                                                                                                           |
| `config.oauth.oauthHTMLLocation`                       | The path of the oauth html file                                                                                                                                 | "/home/appops/authhtml"                                                                                                                                                                                                                                                                                                                         |
| `config.oauth.authorizeCodeExpireIn`                   | The duration of the authorized code                                                                                                                             | 10m                                                                                                                                                                                                                                                                                                                                             |
| `config.oauth.accessTokenExpireIn`                     | The duration of the access token                                                                                                                                | 24h                                                                                                                                                                                                                                                                                                                                             |
| `config.webhook.clientTimeout`                         | The timeout duration of webhook's http client                                                                                                                   | 30                                                                                                                                                                                                                                                                                                                                              |
| `config.webhook.idleWaitInterval`                      | The idleWait internal of webhook's http client                                                                                                                  | 2                                                                                                                                                                                                                                                                                                                                               |
| `config.webhook.workerReconcileInterval`               | The reconcile internal of webhook                                                                                                                               | 5                                                                                                                                                                                                                                                                                                                                               |
| `config.webhook.responseBodyTruncateSize`              | The size that needs to be exceeded when truncating text                                                                                                         | 16384                                                                                                                                                                                                                                                                                                                                           |
| `config.eventHandler.batchEventsCount`                 | The batch events count of the event handler                                                                                                                     | 5                                                                                                                                                                                                                                                                                                                                               |
| `config.eventHandler.cursorSaveInterval`               | The cursor save interval of the event handler                                                                                                                   | 10                                                                                                                                                                                                                                                                                                                                              |
| `config.eventHandler.idleWaitInterval`                 | The idle wait of the event handler's http client                                                                                                                | 3                                                                                                                                                                                                                                                                                                                                               |

### Core deployment parameters

| Name                                | Description                                                                                                                                                                                                                                       | Value                        |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `core.replica`                      | The replica count                                                                                                                                                                                                                                 | 1                            |
| `core.image.repository`             | Repository for Horizon core image                                                                                                                                                                                                                 | horizoncd/horizon            |
| `core.image.tag`                    | Tag for Horizon core image                                                                                                                                                                                                                        | v1.0.0                       |
| `core.args.loglevel`                | Loglevel of Horizon core                                                                                                                                                                                                                          | info                         |
| `core.args.gitOpsRepoDefaultBranch` | Default branch for gitops repository                                                                                                                                                                                                              | main                         |
| `core.securityContext.runAsUser`    | User ID for the container                                                                                                                                                                                                                         | 10001                        |
| `core.securityContext.fsGroup`      | Group ID for the container                                                                                                                                                                                                                        | 10001                        |
| `core.serviceAccount.create`        | Create the serviceAccount or not                                                                                                                                                                                                                  | true                         |
| `core.resources`                    | The [resources] to allocate for container                                                                                                                                                                                                         | {}                           |
| `core.nodeSelector`                 | Node labels for pod assignment                                                                                                                                                                                                                    | {}                           |
| `core.tolerations`                  | Tolerations for pod assignment                                                                                                                                                                                                                    | []                           |
| `core.affinity`                     | Node/Pod affinities                                                                                                                                                                                                                               | {}                           |
| `core.service.port`                 | The port of the core service                                                                                                                                                                                                                      | 80                           |
| `core.cloudEventService.port`       | The port of the cloudevent service                                                                                                                                                                                                                | 80                           |
| `core.cloudEventIngress.enabled`    | Enable ingress of the cloudEvent or not                                                                                                                                                                                                           | true                         |
| `core.cloudEventIngress.hosts`      | The hosts of the cloudEvent's ingress                                                                                                                                                                                                             | []                           |
| `core.envs`                         | The environments in Horizon core                                                                                                                                                                                                                  | {}                           |
| `core.monitor.enabled`              | Enable monitor of Horizon core or not                                                                                                                                                                                                             | false                        |
| `core.grafanaDashboards`            | Grafana dashboards in json format. Please note that the default dashboards are built based on metrics of `Kube-state-metrics:v1.9.7`, you may need to modify the dashboards if you are using a higher verion becuase of renaming in some metrics. | - name: pod<br/>  value: xxx |

### Web deployment parameters

| Name                            | Description                               | Value         |
| ------------------------------- | ----------------------------------------- | ------------- |
| `web.replicas`                  | The replica count                         | 1             |
| `web.image.repository`          | Repository for Horizon web image          | horizoncd/web |
| `web.image.tag`                 | Tag for Horizon web image                 | v1.0.0        |
| `web.securityContext.runAsUser` | User ID for the container                 | 10001         |
| `web.securityContext.fsGroup`   | Group ID for the container                | 10001         |
| `web.resources`                 | The [resources] to allocate for container | {}            |
| `web.nodeSelector`              | Node labels for pod assignment            | {}            |
| `web.tolerations`               | Tolerations for pod assignment            | []            |
| `web.affinity`                  | Node/Pod affinities                       | {}            |
| `web.port`                      | Port of Horizon web container             | 8080          |
| `web.service.port`              | Kubernetes port where service is exposed  | 80            |

### Job deployment parameters

| Name                               | Description                               | Value         |
| ---------------------------------- | ----------------------------------------- | ------------- |
| `job.image.repository`             | Repository for Horizon job image          | horizoncd/job |
| `job.image.tag`                    | Tag for Horizon job image                 | v1.0.0        |
| `job.args.loglevel`                | Loglevel of Horizon job                   | info          |
| `job.args.gitOpsRepoDefaultBranch` | Default branch for gitops repository      | main          |
| `job.securityContext.runAsUser`    | User ID for the container                 | 10001         |
| `job.securityContext.fsGroup`      | Group ID for the container                | 10001         |
| `job.serviceAccount.create`        | Create the serviceAccount or not          | true          |
| `job.resources`                    | The [resources] to allocate for container | {}            |
| `job.nodeSelector`                 | Node labels for pod assignment            | {}            |
| `job.tolerations`                  | Tolerations for pod assignment            | []            |
| `job.affinity`                     | Node/Pod affinities                       | {}            |

### Swagger deployment parameters

| Name                                | Description                                                   | Value                 |
| ----------------------------------- | ------------------------------------------------------------- | --------------------- |
| `swagger.replicas`                  | The replica count                                             | 1                     |
| `swagger.image.repository`          | Repository for Horizon swagger image                          | horizoncd/swagger     |
| `swagger.image.tag`                 | Tag for Horizon swagger image                                 | v1.0.0                |
| `swagger.securityContext.runAsUser` | User ID for the container                                     | 10001                 |
| `swagger.securityContext.fsGroup`   | Group ID for the container                                    | 10001                 |
| `swagger.envs.BASE_URL`             | Environment named `BSE_URL` in Horizon swagger container      | /apis/swagger         |
| `swagger.envs.SWAGGER_JSON`         | Environment named `SWAGGER_JSON` in Horizon swagger container | /openapi/restful.json |
| `swagger.service.port`              | Kubernetes port where service is exposed                      | 80                    |
| `swagger.service.targetPort`        | The port on which the service will send requests to           | 8080                  |
| `swagger.resources`                 | The [resources] to allocate for container                     | {}                    |

### Third-party components parameters

Horizon has the ability to initialize third-party components conveniently to build the whole CI&CD system. 

**Attention**:

- By default, the components(Mysql、Gitlab、Minio、Harbor) that are initialized by Horizon use `PVC` to persistent data,
  which means a default `StorageClass` is needed in the Kubernetes cluster to dynamic provision the volumes.

- You can definitely use your own maintained components for sure, to do that, just set the `enabled` field to false, and then fill in the corresponding fields with your own configurations. More information will be explained below.

#### Minio

We use `Minio` as the `s3` storage service. The default parameters are:

```
minio:
  enabled: true
  ingress:
    enabled: true
    hostname: minio.h8r.site
  persistence:
    enabled: true
  defaultBuckets: horizon
  auth:
    rootUser: admin
    rootPassword: qOIh3Xt5jg
  provisioning:
    enabled: true
    config:
      - name: region
        options:
          name: china
```

If you want to use your own `s3` storage service, you need to do the following steps:

1. disable `minio` by setting the `enabled` field to false

2. modify `Tekton` config in the path: `config.tektonMapper.[environment].s3`

3. modify `Harbor` config in the path: `harbor.persistence.imageChartStorage.s3`

4. Modify `Chartmusuem` config in the path: `chartmuseum.env.open` and `chartmuseum.env.secret`

#### Gitlab

We use `Gitlab` as the `gitops` repository. The default parameters are:

```
gitlab:
  enabled: true
  image: gitlab/gitlab-ce
  imageTag: "13.11.7-ce.0"
  ingress:
    enabled: true
    hosts:
      - gitlab.h8r.site
  persistence:
    enabled: true
  config:
    GITLAB_ROOT_PASSWORD: root1234
    GITLAB_ROOT_ACCESS_TOKEN: horizon-access-token
    GITLAB_HOST: gitlab.h8r.site
    GITLAB_TIMEZONE: "Asia/Shanghai"
  resources:
    requests:
      memory: 4Gi
      cpu: 2
    limits:
      memory: 4Gi
      cpu: 2
```

If you want to use your own `gitlab` instance, you need to do the following steps:

1. disable `gitlab` by setting the `enabled` field to false

2. modify gitops config in path: `cnofig.gitopsRepoConfig`

#### Chartmuseum

We use `Chartmuseum` as the helm chart repository. The default parameters are:

```
chartmuseum:
  enabled: true
  ingress:
    enabled: true
    hosts:
      - name: chartmuseum.h8r.site
  env:
    open:
      # storage backend, can be one of: local, alibaba, amazon, google, microsoft, oracle
      STORAGE: amazon
      # s3 bucket to store charts for amazon storage backend
      STORAGE_AMAZON_BUCKET: horizon
      # region of s3 bucket to store charts
      STORAGE_AMAZON_REGION: china
      # alternative s3 endpoint
      STORAGE_AMAZON_ENDPOINT: "http://horizon-minio:9000"
      DISABLE_API: false
    secret:
      AWS_ACCESS_KEY_ID: admin
      AWS_SECRET_ACCESS_KEY: qOIh3Xt5jg
```

If you want to use your own helm chart repository, you need to do the following steps:

1. disable `chartmuseum` by setting the `enabled` field to false

2. modify helm template config in path: `cnofig.templateRepo`

#### Mysql

We use `Mysql` as the database. The default parameters are:

```
mysql:
  enabled: true
  auth:
    rootPassword: "horizon"
    createDatabase: true
    database: "horizon"
  initdbScriptsConfigMap: horizon-dbinit
  primary:
    resources:
      limits:
        cpu: 250m
        memory: 1Gi
      requests:
        cpu: 100m
        memory: 500Mi
```

If you want to use your own database, you need to do the following steps:

1. disable `mysql` by setting the `enabled` field to false

2. modify database config in path: `cnofig.dbConfig`

#### Harbor

We use `Harbor` as the image repository. The default parameters are:

```
harbor:
  enabled: true
  expose:
    type: clusterIP
    tls:
      auto:
        commonName: "harbor.horizoncd.svc.cluster.local"
    clusterIP:
      name: harbor
  externalURL: https://harbor.horizoncd.svc.cluster.local
  persistence:
    imageChartStorage:
      disableredirect: true
      type: s3
      s3:
        region: china
        bucket: horizon
        accesskey: admin
        secretkey: qOIh3Xt5jg
        regionendpoint: http://horizon-minio:9000
        secure: false
        skipverify: true
  redis:
    type: external
    external:
      addr: "horizon-redis-ha:6379"
  chartmuseum:
    enabled: false
  core:
    replicas: 1
  jobservice:
    replicas: 1
  registry:
    replicas: 1
  notary:
    enabled: false
  trivy:
    enabled: false
```

If you want to use your own image repository, you need to do the following steps:

1. disable `harbor` by setting the `enabled` field to false

2. Add `Registry` in the Horizon manager web

#### Grafana

We use `Grafana` as the monitoring display system. The default parameters are:

```
grafana:
  enabled: true
  defaultDashboardsEnabled: true
  adminPassword: admin
  ingress:
    enabled: true
    hosts:
      - grafana.h8r.site
    path: /
  sidecar:
    dashboards:
      enabled: true
    datasources:
      enabled: true
  grafana.ini:
    auth.anonymous:
      enabled: true
    security:
      allow_embedding: true
```

If you want to use your own Grafana instance, you need to do the following steps:

1. disable `grafana` by setting the `enabled` field to false

2. Modify `grafana` config in the path: `config.grafanaConfig`

#### Tektoncd

We use `Tektoncd` as the CI tool. The default parameters are:

```
tektoncd:
  enabled: true
  configDefaults:
    default-cloud-events-sink: http://horizon-core-cloudevent.horizoncd/apis/internal/cloudevents
  tektonDashboard:
    ingress:
      host: tekton.h8s.site
```

If you want to use your own `Tektoncd` instance, you need to do the following steps:

1. disable `tektoncd` by setting the `enabled` field to false

2. Modify tektoncd config in the path: `config.tektonMapper.[environment]`

#### Tektonci-resources

We have embedded `Tekton Pipeline & Task` as the default CI definition. The default parameters are:

```
tektonci-resources:
  auth:
    dockerConfigJson: {    "auths":    {        "harbor.horizoncd.svc.cluster.local":        {            "username": "admin",            "password": "Harbor12345",            "auth": "YWRtaW46SGFyYm9yMTIzNDU="        }    }}
  gitRepos:
    ssh: []
    http: []
  extraVolumeMounts: []
```

If you want to define your own CI logics, please refer to [custom CI instructions](https://horizoncd.github.io/docs/tutorials/custom-ci)
