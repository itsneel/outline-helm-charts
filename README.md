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
| `outline.fileStorage.type`              | Storage type (`local` or `s3`)                                                | `local`                  |
| `outline.fileStorage.uploadMaxSize`     | Maximum upload size for files                                                 | `26214400`               |
| `outline.fileStorage.localRootDir`      | Root directory for local file storage                                         | `/var/lib/outline/data`  |
| `outline.persistence.enabled`           | Enable persistence using PVC (for local storage type)                         | `true`                   |
| `outline.persistence.accessMode`        | PVC Access Mode                                                               | `ReadWriteOnce`          |
| `outline.persistence.size`              | PVC Storage Request                                                           | `10Gi`                   |
| `outline.persistence.storageClass`      | Storage class of backing PVC                                                  | `""`                     |
| `serviceAccount.*`                      | Service account configuration (for S3 IAM role binding)                       | See values.yaml          |
| `env`                                   | Outline environment variables                                                 | Check `values.yaml` file |
| `envSecrets`                            | Outline sensitive environment variables (stored as secrets)                   | Check `values.yaml` file |
| `secrets`                               | Additional secrets to be stored in Kubernetes Secret                          | `{}`                     |

### S3 Storage Configuration

When using S3 storage, you can either use MinIO (deployed as part of the chart) or an external S3-compatible service:

| Name                                  | Description                                                                   | Value                  |
| ------------------------------------- | ----------------------------------------------------------------------------- | ---------------------- |
| `outline.fileStorage.type`            | Set to `s3` to use S3 storage instead of local storage                        | `local`                |
| `minio.enabled`                       | Whether to deploy MinIO as part of the release                                | `false`                |
| `minio.auth.existingSecret`           | Reference to existing secret with MinIO credentials                           | `""`                   |
| `minio.s3Config.region`               | AWS/S3 region                                                                 | `us-east-1`            |
| `minio.s3Config.uploadBucketUrl`      | S3 bucket URL                                                                 | `""`                   |
| `minio.s3Config.uploadBucketName`     | S3 bucket name                                                                | `outline`              |
| `minio.s3Config.forcePathStyle`       | Use path style access for S3 (required for some S3-compatible services)       | `true`                 |
| `minio.s3Config.acl`                  | S3 ACL to use                                                                 | `private`              |
| `serviceAccount.create`               | Whether to create a service account                                           | `false`                |
| `serviceAccount.annotations`          | Annotations to add to the service account (for IAM role binding)              | `{}`                   |
| `serviceAccount.name`                 | Name of the service account                                                   | `""`                   |

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
  fileStorage:
    type: local
    localRootDir: /var/lib/outline/data
    uploadMaxSize: "26214400"
  persistence:
    enabled: true
    size: 10Gi
```

### Using MinIO for S3-Compatible Storage

To use the bundled MinIO for S3-compatible storage:

```yaml
outline:
  fileStorage:
    type: s3
    uploadMaxSize: "26214400"

minio:
  enabled: true
  auth:
    rootUser: "minio-admin"
    rootPassword: "change-me-in-production"
  s3Config:
    region: "us-east-1"
    uploadBucketUrl: "http://minio:9000"
    uploadBucketName: outline
    forcePathStyle: true
    acl: private
```

### Using AWS S3 with IAM Role (Service Account)

For AWS EKS with IAM Roles for Service Accounts (IRSA):

```yaml
outline:
  fileStorage:
    type: s3
    uploadMaxSize: "26214400"

minio:
  enabled: false

env:
  AWS_REGION: "us-east-1"
  AWS_S3_UPLOAD_BUCKET_URL: "https://s3.amazonaws.com"
  AWS_S3_UPLOAD_BUCKET_NAME: "my-outline-bucket"
  AWS_S3_FORCE_PATH_STYLE: "false"

serviceAccount:
  create: true
  annotations:
    eks.amazonaws.com/role-arn: "arn:aws:iam::123456789012:role/outline-s3-role"
```

### Using AWS S3 with Access Keys

To use AWS S3 with access keys:

```yaml
outline:
  fileStorage:
    type: s3
    uploadMaxSize: "26214400"

minio:
  enabled: false

env:
  AWS_REGION: "us-east-1"
  AWS_S3_UPLOAD_BUCKET_URL: "https://s3.amazonaws.com"
  AWS_S3_UPLOAD_BUCKET_NAME: "my-outline-bucket"
  AWS_S3_FORCE_PATH_STYLE: "false"

envSecrets:
  AWS_ACCESS_KEY_ID:
    secretName: "outline-aws-secrets"
    secretKey: "access-key-id"
  AWS_SECRET_ACCESS_KEY:
    secretName: "outline-aws-secrets"
    secretKey: "secret-access-key"
```

## Authentication Configuration

Outline requires at least one authentication provider. The configuration is now at the top level under the `auth` key:

```yaml
auth:
  type: "google" # One of: google, slack, oidc, azure

  # Google OAuth configuration
  google:
    CLIENT_ID:
      secretName: "google-oauth-secret"
      secretKey: "client-id"
    CLIENT_SECRET:
      secretName: "google-oauth-secret"
      secretKey: "client-secret"
```

Other available providers:

```yaml
# Slack authentication
auth:
  type: "slack"
  slack:
    CLIENT_ID:
      secretName: "slack-oauth-secret"
      secretKey: "client-id"
    CLIENT_SECRET:
      secretName: "slack-oauth-secret"
      secretKey: "client-secret"

# Azure authentication
auth:
  type: "azure"
  azure:
    CLIENT_ID:
      secretName: "azure-oauth-secret"
      secretKey: "client-id"
    CLIENT_SECRET:
      secretName: "azure-oauth-secret"
      secretKey: "client-secret"
    TENANT_ID:
      secretName: "azure-oauth-secret"
      secretKey: "tenant-id"

# OIDC authentication
auth:
  type: "oidc"
  oidc:
    AUTH_URI:
      secretName: "oidc-secret"
      secretKey: "auth-uri"
    TOKEN_URI:
      secretName: "oidc-secret"
      secretKey: "token-uri"
    USERINFO_URI:
      secretName: "oidc-secret"
      secretKey: "userinfo-uri"
    CLIENT_ID:
      secretName: "oidc-secret"
      secretKey: "client-id"
    CLIENT_SECRET:
      secretName: "oidc-secret"
      secretKey: "client-secret"
```

## Minimum Required Configuration

At minimum, you need to set:

1. Authentication provider credentials in the `auth` section
2. Generate secrets for `SECRET_KEY` and `UTILS_SECRET` in the `secrets` section
3. Set a proper `URL` for your deployment

Example minimal configuration:

```yaml
env:
  URL: "https://your-outline-domain.com"

secrets:
  SECRET_KEY:
    secretName: "outline-secrets"
    secretKey: "secret-key"
  UTILS_SECRET:
    secretName: "outline-secrets"
    secretKey: "utils-secret"

auth:
  type: "google"
  google:
    CLIENT_ID:
      secretName: "google-oauth-secret"
      secretKey: "client-id"
    CLIENT_SECRET:
      secretName: "google-oauth-secret"
      secretKey: "client-secret"
```

### Security and Secret Management

The chart automatically handles sensitive information securely:

1. Environment variables containing sensitive data (those with names containing `CLIENT_ID`, `CLIENT_SECRET`, `SECRET`, or `KEY`) are automatically detected and stored in Kubernetes Secrets.
2. You can explicitly define sensitive data in either:
   - `envSecrets` - For environment variables containing secrets
   - `secrets` - For application secrets like `SECRET_KEY` and `UTILS_SECRET`

Sensitive values are never stored as plain text and are securely passed to the application using Kubernetes Secret references.

## Example Values Files

The chart includes several example values files in the `charts/outline/examples` directory to help you get started with common deployment scenarios:

### Complete Production Examples

These files provide comprehensive examples for different production setups:

- `production-s3.yaml`: Uses MinIO for S3-compatible storage
  ```bash
  helm install my-outline ./charts/outline -f charts/outline/examples/production-s3.yaml
  ```

- `production-aws-s3.yaml`: Uses AWS S3 directly (no MinIO)
  ```bash
  helm install my-outline ./charts/outline -f charts/outline/examples/production-aws-s3.yaml
  ```

- `production-local-storage.yaml`: Uses local storage with persistent volumes
  ```bash
  helm install my-outline ./charts/outline -f charts/outline/examples/production-local-storage.yaml
  ```

### Component-Specific Configurations

The chart also includes modular configuration examples for specific components:

- `auth-configurations.yaml`: Authentication options (Google, Slack, Azure, OIDC)
- `database-configurations.yaml`: Database options (internal or external PostgreSQL)
- `storage-configurations.yaml`: Storage options (local, MinIO, AWS S3 with keys or IAM)

These can be combined to create custom configurations:

```bash
# Install with external PostgreSQL and AWS S3 storage
helm install my-outline ./charts/outline \
  -f charts/outline/examples/database-configurations.yaml \
  -f charts/outline/examples/storage-configurations.yaml \
  --set-file "database=external-postgresql" \
  --set-file "storage=aws-s3-keys"
```

See the [examples README](charts/outline/examples/README.md) for more details on using these examples.
