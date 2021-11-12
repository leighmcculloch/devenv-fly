FLY_ORG?=personal
FLY_APP?=flydev

logs:
	fly logs -a $(FLY_APP)

status:
	fly status -a $(FLY_APP)
	fly scale show -a $(FLY_APP)

create1:
	fly apps create --org $(FLY_ORG) $(FLY_APP)
	$(MAKE) size1
	$(MAKE) deploy

create8:
	fly apps create --org $(FLY_ORG) $(FLY_APP)
	$(MAKE) size8
	$(MAKE) deploy

build:
	docker build . -t flydev

deploy:
	fly deploy --remote-only -a $(FLY_APP)
	$(MAKE) logs

restart:
	fly vm status $$(fly status -a $(FLY_APP) --json | jq -r '.App.Allocations[0].IDShort') -a $(FLY_APP)
	fly vm restart $$(fly status -a $(FLY_APP) --json | jq -r '.App.Allocations[0].IDShort') -a $(FLY_APP)

size1:
	fly scale vm -a $(FLY_APP) shared-cpu-1x --memory=2048

size8:
	fly scale vm -a $(FLY_APP) dedicated-cpu-8x --memory=16384

destroy:
	fly apps destroy -y $(FLY_APP)
