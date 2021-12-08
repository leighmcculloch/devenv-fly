FLY_ORG?=personal
FLY_APP?=de4l
FLY_REGION?=sjc
TAILSCALE_AUTHKEY?=

# STATUS

logs:
	fly logs -a $(FLY_APP)

status:
	fly status -a $(FLY_APP)
	fly scale show -a $(FLY_APP)
	fly volumes list -a $(FLY_APP)

# SETUP AND DESTROY

setup:
	fly apps create --org $(FLY_ORG) $(FLY_APP)
	fly secrets set -a $(FLY_APP) TAILSCALE_AUTHKEY=$(TAILSCALE_AUTHKEY)

destroy:
	fly apps destroy -y $(FLY_APP)

# INSTANCE

create:
	fly volumes create -a $(FLY_APP) --region $(FLY_REGION) --size 40 data
	$(MAKE) size8
	$(MAKE) push

terminate:
	fly volumes delete -a $(FLY_APP) --region $(FLY_REGION) --size 40 data
	fly scale -a $(FLY_APP) count 0

push:
	fly deploy -a $(FLY_APP) --remote-only --strategy immediate

start:
	fly scale -a $(FLY_APP) count 1

stop:
	fly scale -a $(FLY_APP) count 0

size1:
	fly scale vm -a $(FLY_APP) shared-cpu-1x --memory=2048

size8:
	fly scale vm -a $(FLY_APP) dedicated-cpu-8x --memory=16384
