# Outline Helm Chart

This Helm chart deploys [Outline](https://github.com/outline/outline), a modern team knowledge base and wiki.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (if persistence is enabled)

## Installing the Chart

To install the chart with the release name `my-outline`:

```bash
# Add Bitnami repository for dependencies
helm repo add bitnami https://charts.bitnami.com/bitnami

# Update dependencies
cd charts/outline
helm dependency update

# Install the chart
helm install my-outline ./charts/outline
```

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-outline` deployment:

```bash
helm delete my-outline
```

## Parameters

### Global parameters

| Name                | Description                                                                                       | Value       |
| ------------------- | ------------------------------------------------------------------------------------------------- | ----------- |
| `global.env`        | Environment to run the application in                                                             | `production` |

### Outline parameters

| Name                                    | Description                                                                   | Value                    |
| --------------------------------------- | ----------------------------------------------------------------------------- | ------------------------ |
| `outline.replicaCount`                  | Number of Outline replicas to deploy                                          | `1`                      |
| `outline.image.repository`              | Outline image repository                                                      | `outlinewiki/outline`    |
| `outline.image.tag`                     | Outline image tag (immutable tags are recommended)                            | `latest`                 |
| `outline.image.pullPolicy`              | Outline image pull policy                                                     | `IfNotPresent`           |
| `outline.containerPort`                 | Container port                                                                | `3000`                   |
| `outline.service.type`                  | Outline service type                                                          | `ClusterIP`              |
| `outline.service.port`                  | Outline service port                                                          | `80`                     |
| `outline.ingress.enabled`               | Enable ingress controller resource                                            | `false`                  |
| `outline.ingress.className`             | IngressClass that will be used to implement the Ingress                       | `""`                     |
| `outline.ingress.annotations`           | Additional annotations for the Ingress resource                               | `{}`                     |
| `outline.ingress.hosts`                 | Hosts configuration for the Ingress controller                                | `[{"host": "outline.local", "paths": [{"path": "/", "pathType": "Prefix"}]}]` |
| `outline.ingress.tls`                   | TLS configuration for the Ingress controller                                  | `[]`                     |
| `outline.storage.type`                  | Storage type (`local` or `s3`)                                                | `local`                  |
| `outline.storage.s3.*`                  | S3 storage configuration (see below)                                          | See values.yaml          |
| `outline.persistence.enabled`           | Enable persistence using PVC (for local storage type)                         | `true`                   |
| `outline.persistence.accessMode`        | PVC Access Mode                                                               | `ReadWriteOnce`          |
| `outline.persistence.size`              | PVC Storage Request                                                           | `10Gi`                   |
| `outline.persistence.storageClass`      | Storage class of backing PVC                                                  | `""`                     |
| `outline.serviceAccount.*`              | Service account configuration (for S3 IAM role binding)                       | See values.yaml          |
| `outline.env`                           | Outline environment variables                                                 | Check `values.yaml` file |
| `outline.envSecrets`                    | Outline sensitive environment variables (stored as secrets)                   | Check `values.yaml` file |

### S3 Storage Configuration

| Name                                      | Description                                                                   | Value                  |
| ----------------------------------------- | ----------------------------------------------------------------------------- | ---------------------- |
| `outline.storage.type`                    | Set to `s3` to use S3 storage instead of local storage                        | `local`                |
| `outline.storage.s3.useServiceAccount`    | Whether to use IAM role-based authentication (via service account)            | `false`                |
| `outline.storage.s3.accessKey`            | AWS access key (when not using service account)                               | `""`                   |
| `outline.storage.s3.secretKey`            | AWS secret key (when not using service account)                               | `""`                   |
| `outline.storage.s3.region`               | AWS region                                                                    | `us-east-1`            |
| `outline.storage.s3.bucket`               | S3 bucket name                                                                | `""`                   |
| `outline.storage.s3.bucketUrl`            | S3 bucket URL                                                                 | `""`                   |
| `outline.storage.s3.forcePathStyle`       | Use path style access for S3 (required for some S3-compatible services)       | `false`                |
| `outline.storage.s3.acl`                  | S3 ACL to use                                                                 | `private`              |
| `outline.storage.s3.isCustomEndpoint`     | Set to true for custom S3-compatible storage                                  | `false`                |
| `outline.serviceAccount.create`           | Whether to create a service account                                           | `false`                |
| `outline.serviceAccount.annotations`      | Annotations to add to the service account (for IAM role binding)              | `{}`                   |
| `outline.serviceAccount.name`             | Name of the service account                                                   | `""`                   |

### PostgreSQL parameters

| Name                                   | Description                                                                    | Value            |
| -------------------------------------- | ------------------------------------------------------------------------------ | ---------------- |
| `postgresql.enabled`                    | Deploy a PostgreSQL server as part of this release                            | `true`           |
| `postgresql.external.host`              | External PostgreSQL host (when `enabled=false`)                                | `""`             |
| `postgresql.external.port`              | External PostgreSQL port (when `enabled=false`)                                | `5432`           |
| `postgresql.external.database`          | External PostgreSQL database name (when `enabled=false`)                       | `outline`        |
| `postgresql.external.user`              | External PostgreSQL user (when `enabled=false`)                                | `outline`        |
| `postgresql.external.password`          | External PostgreSQL password (when `enabled=false`)                            | `""`             |
| `postgresql.external.existingSecret`    | Name of an existing secret with PostgreSQL credentials (when `enabled=false`) | `""`             |
| `postgresql.external.existingSecretKey` | Key in existing secret with PostgreSQL password (when `enabled=false`)        | `""`             |
| `postgresql.postgresqlUsername`         | PostgreSQL username (when `enabled=true`)                                      | `outline`        |
| `postgresql.postgresqlPassword`         | PostgreSQL password (when `enabled=true`)                                      | `""`             |
| `postgresql.postgresqlDatabase`         | PostgreSQL database name (when `enabled=true`)                                 | `outline`        |
| `postgresql.persistence.enabled`        | Enable PostgreSQL persistence using PVC                                        | `true`           |
| `postgresql.persistence.size`           | PostgreSQL PVC Storage Request                                                 | `8Gi`            |

### Redis parameters

| Name                                | Description                                                              | Value        |
| ----------------------------------- | ------------------------------------------------------------------------ | ------------ |
| `redis.enabled`                     | Deploy a Redis server as part of this release                            | `true`       |
| `redis.external.host`               | External Redis host (when `enabled=false`)                               | `""`         |
| `redis.external.port`               | External Redis port (when `enabled=false`)                               | `6379`       |
| `redis.external.password`           | External Redis password (when `enabled=false`)                           | `""`         |
| `redis.external.existingSecret`     | Name of an existing secret with Redis credentials (when `enabled=false`) | `""`         |
| `redis.external.existingSecretKey`  | Key in existing secret with Redis password (when `enabled=false`)        | `""`         |
| `redis.password`                    | Redis password (when `enabled=true`)                                     | `""`         |
| `redis.persistence.enabled`         | Enable Redis persistence using PVC                                        | `true`       |
| `redis.persistence.size`            | Redis PVC Storage Request                                                 | `1Gi`        |

## External Database / Redis Configuration

### Using an External PostgreSQL Database

To use an external PostgreSQL server, set `postgresql.enabled=false` and configure the external database connection:

```yaml
postgresql:
  enabled: false
  external:
    host: "your-external-postgres-host"
    port: 5432
    database: "outline"
    user: "outline-user"
    password: "your-password"
    # Or use an existing secret
    # existingSecret: "postgres-secret"
    # existingSecretKey: "postgres-password"
```

### Using an External Redis Server

To use an external Redis server, set `redis.enabled=false` and configure the external Redis connection:

```yaml
redis:
  enabled: false
  external:
    host: "your-external-redis-host"
    port: 6379
    password: "your-password"
    # Or use an existing secret
    # existingSecret: "redis-secret"
    # existingSecretKey: "redis-password"
```

## Storage Configuration

Outline supports two storage modes: local (within the container) and S3-compatible object storage.

### Using Local Storage (Default)

Local storage is enabled by default:

```yaml
outline:
  storage:
    type: local
  persistence:
    enabled: true
    size: 10Gi
```

### Using S3 Storage with IAM Role (Service Account)

For AWS EKS with IAM Roles for Service Accounts (IRSA):

```yaml
outline:
  storage:
    type: s3
    s3:
      useServiceAccount: true
      region: "us-east-1"
      bucket: "your-outline-bucket"
      bucketUrl: "https://your-outline-bucket.s3.amazonaws.com"

  serviceAccount:
    create: true
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::123456789012:role/outline-s3-role"
```

For GCP GKE with Workload Identity:

```yaml
outline:
  storage:
    type: s3
    s3:
      useServiceAccount: true
      region: "us-east-1"
      bucket: "your-outline-bucket"
      bucketUrl: "https://your-outline-bucket.s3.amazonaws.com"

  serviceAccount:
    create: true
    annotations:
      iam.gke.io/gcp-service-account: "outline-sa@your-project.iam.gserviceaccount.com"
```

### Using S3 Storage with Access Keys

```yaml
outline:
  storage:
    type: s3
    s3:
      useServiceAccount: false
      accessKey: "your-aws-access-key"
      secretKey: "your-aws-secret-key"
      region: "us-east-1"
      bucket: "your-outline-bucket"
      bucketUrl: "https://your-outline-bucket.s3.amazonaws.com"
```

### Using MinIO or other S3-compatible Storage

```yaml
outline:
  storage:
    type: s3
    s3:
      useServiceAccount: false
      accessKey: "your-minio-access-key"
      secretKey: "your-minio-secret-key"
      region: "us-east-1"
      bucket: "outline"
      bucketUrl: "https://your-minio-instance/outline"
      forcePathStyle: true
      isCustomEndpoint: true
```

## Authentication Configuration

Outline requires at least one authentication provider. Configure at least one of these in the `outline.env` section:

```yaml
outline:
  env:
    # For Slack
    SLACK_CLIENT_ID: "your-slack-client-id"
    SLACK_CLIENT_SECRET: "your-slack-client-secret"

    # For Google
    GOOGLE_CLIENT_ID: "your-google-client-id"
    GOOGLE_CLIENT_SECRET: "your-google-client-secret"

    # For Microsoft/Azure
    AZURE_CLIENT_ID: "your-azure-client-id"
    AZURE_CLIENT_SECRET: "your-azure-client-secret"
    AZURE_RESOURCE_APP_ID: "your-azure-resource-app-id"
```

## Minimum Required Configuration

At minimum, you need to set:

1. Authentication provider credentials
2. Generate secrets for `SECRET_KEY` and `UTILS_SECRET`
3. Set a proper `URL` for your deployment

Example minimal configuration:

```yaml
outline:
  env:
    URL: "https://your-outline-domain.com"
    GOOGLE_CLIENT_ID: "your-google-client-id"
    GOOGLE_CLIENT_SECRET: "your-google-client-secret"

  envSecrets:
    SECRET_KEY: "your-random-32-byte-hex-key"
    UTILS_SECRET: "your-random-32-byte-hex-key"
```
