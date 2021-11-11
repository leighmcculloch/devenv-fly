FLY_ORG?=personal
FLY_APP?=flydev

deploy:
	fly deploy --local-only -a $(FLY_APP)
	$(MAKE) logs

build:
	docker build .

create:
	fly apps create --org $(FLY_ORG) $(FLY_APP)
	$(MAKE) size1

size1:
	fly scale vm -a $(FLY_APP) shared-cpu-1x --memory=2048

size8:
	fly scale vm -a $(FLY_APP) dedicated-cpu-8x --memory=16384

destroy:
	fly apps destroy -y $(FLY_APP)

logs:
	fly logs -a $(FLY_APP)
