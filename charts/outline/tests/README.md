# Outline Helm Chart Tests

This directory contains unit tests for the Outline Helm chart. These tests validate that the chart templates render correctly with various configurations.

## Running the Tests

To run the tests, you need to have the Helm unittest plugin installed:

```bash
helm plugin install https://github.com/quintush/helm-unittest
```

Then, from the chart directory, run:

```bash
cd charts/outline
helm unittest .
```

## Test Files

The test files are organized by template:

- `configmap_test.yaml`: Tests for the ConfigMap template
- `deployment_test.yaml`: Tests for the Deployment template
- `ingress_test.yaml`: Tests for the Ingress template
- `pvc_test.yaml`: Tests for the PersistentVolumeClaim template
- `s3_secrets_test.yaml`: Tests for the S3 secrets template
- `secrets_test.yaml`: Tests for the Secrets template
- `service_test.yaml`: Tests for the Service template
- `serviceaccount_test.yaml`: Tests for the ServiceAccount template

## Adding New Tests

To add a new test, create a new YAML file in this directory with the following structure:

```yaml
suite: test suite name
templates:
  - template-to-test.yaml
tests:
  - it: should do something
    set:
      # Values to set for this test
      key: value
    asserts:
      # Assertions to validate the rendered template
      - equal:
          path: some.path
          value: expected-value
```

For more information on writing tests, see the [Helm unittest plugin documentation](https://github.com/quintush/helm-unittest).
