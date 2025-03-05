# Outline Helm Chart - Example Values

This directory contains example values files for various configurations of the Outline Helm chart.

## Complete Production Examples

These files provide comprehensive examples for different production setups:

- `production-s3.yaml`: Uses MinIO for S3-compatible storage
- `production-aws-s3.yaml`: Uses AWS S3 directly (no MinIO)
- `production-local-storage.yaml`: Uses local storage with persistent volumes

## Component-Specific Configurations

These files provide modular configurations for specific components:

- `auth-configurations.yaml`: Authentication options (Google, Slack, Azure, OIDC)
- `database-configurations.yaml`: Database options (internal or external PostgreSQL)
- `storage-configurations.yaml`: Storage options (local, MinIO, AWS S3 with keys or IAM)

## Usage

### Using a complete production example:

```bash
helm install my-release ./charts/outline -f charts/outline/examples/production-s3.yaml
```

### Combining component-specific configurations:

```bash
# Install with external PostgreSQL and AWS S3 storage
helm install my-release ./charts/outline \
  -f charts/outline/examples/database-configurations.yaml \
  -f charts/outline/examples/storage-configurations.yaml \
  --set database=external-postgresql \
  --set storage=aws-s3-keys
```

### Overriding specific values:

```bash
# Use the production S3 example but override the hostname
helm install my-release ./charts/outline \
  -f charts/outline/examples/production-s3.yaml \
  --set ingress.hosts[0].host=wiki.mydomain.com
```

### Securely handling sensitive values:

Create a file named `secrets.yaml` with your sensitive values:

```yaml
secrets:
  SECRET_KEY: "your-generated-secret-key"
  UTILS_SECRET: "your-generated-utils-secret"

auth:
  google:
    CLIENT_ID: "your-google-client-id"
    CLIENT_SECRET: "your-google-client-secret"
```

Then include this file when installing:

```bash
helm install my-release ./charts/outline \
  -f charts/outline/examples/production-s3.yaml \
  -f secrets.yaml
```

Make sure to keep `secrets.yaml` out of version control (.gitignore).

## Important Notes

1. Always change default passwords and secrets before deploying to production.
2. Generate secure keys for `SECRET_KEY` and `UTILS_SECRET` using:
   ```bash
   openssl rand -hex 32
   ```
3. Configure at least one authentication provider (Google, Slack, Azure, or OIDC).
4. If using S3 storage, ensure proper permissions are configured.
5. For production use, it's recommended to use external PostgreSQL and Redis instances.
6. Review the official Outline documentation at https://docs.getoutline.com/ for additional configuration options and requirements.
