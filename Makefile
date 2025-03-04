.PHONY: lint test template all clean render-build

all: lint test template render-build

# Add the necessary Helm repositories
repos:
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo update

# Lint the Helm charts
lint:
	helm lint charts/outline/

# Run the tests
test:
	if [ -d "charts/outline/tests" ]; then \
		cd charts/outline && helm unittest .; \
	else \
		echo "No unit tests found for Outline chart, skipping"; \
	fi

# Render the template
template:
	helm template charts/outline --debug

# Clean the build directory
clean:
	rm -rf build/*
	mkdir -p build

# Render charts into build directory with a clean start
render-build: clean
	# Render the main chart
	helm template charts/outline > build/outline-rendered.yaml

	# Render with different values files
	helm template -f charts/outline/values/values-s3-keys.yaml charts/outline > build/outline-s3-keys-rendered.yaml
	helm template -f charts/outline/values/values-s3-iam.yaml charts/outline > build/outline-s3-iam-rendered.yaml
	helm template -f charts/outline/values/values-external-db.yaml charts/outline > build/outline-external-db-rendered.yaml

	echo "Charts rendered in build directory"

# Validate the chart installation
validate:
	helm install --dry-run --debug release-name charts/outline

# Update the chart dependencies
deps:
	helm dependency update charts/outline

# Check for chart issues using chart-testing
ct-lint:
	ct lint --check-version-increment=false --all

# Run the CI tests
ci: lint template test validate


check:
	# helm repo add outline https://itsneel.github.io/outline-helm-charts
	helm repo update
	helm search repo outline --versions
