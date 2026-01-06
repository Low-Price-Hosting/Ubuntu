# This target generates rockcraft.yaml from rockcraft.yaml.template by replacing
# the placeholders __BUILD_BASE__, __RELEASE__, and __SUITE__.
# It determines the __BUILD_BASE__ by checking if the specified RELEASE is
# already supported in Rockcraft schema as a build-base. If not, it uses "devel"
# as the __BUILD_BASE__.
rockcraft.yaml:
	@if [ -z "$(RELEASE)" ] || [ -z "$(SUITE)" ]; then \
		echo "Error: RELEASE and SUITE environment variables must be set"; \
		exit 1; \
	fi; \
	JQ_QUERY='.properties.["build-base"].anyOf[0].enum | contains(["ubuntu@$(RELEASE)"])' ;\
	ROCKCRAFT_SUPPORTS_RELEASE=$$(curl -fsSL https://raw.githubusercontent.com/canonical/rockcraft/main/schema/rockcraft.json | jq "$$JQ_QUERY"); \
	if [ "$$ROCKCRAFT_SUPPORTS_RELEASE" != "true" ]; then \
		BUILD_BASE="devel"; \
	else \
		BUILD_BASE="ubuntu@$(RELEASE)"; \
	fi; \
	sed -e "s/__RELEASE__/$(RELEASE)/g" \
		-e "s/__SUITE__/$(SUITE)/g" \
		-e "s/__BUILD_BASE__/$$BUILD_BASE/g" \
		rockcraft.yaml.template > rockcraft.yaml

.PHONY: clean
clean:
	rm -f rockcraft.yaml
