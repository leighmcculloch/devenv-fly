FLY_ORG?=personal
FLY_APP?=flydev

deploy: build
	fly deploy -a $(FLY_APP)

build:
	docker build .

create:
	fly apps create --org $(FLY_ORG) $(FLY_APP)
	$(MAKE) size1

size1:
	fly scale vm -a $(FLY_APP) dedicated-cpu-8x --memory=16384

size8:
	fly scale vm -a $(FLY_APP) shared-cpu-1x --memory=2048

destroy:
	fly apps destroy -y $(FLY_APP)

logs:
	fly logs -a $(FLY_APP)
