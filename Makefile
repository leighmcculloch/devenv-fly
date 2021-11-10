FLY_ORG?=personal
FLY_APP?=leighdev

deploy: build
	fly deploy -a $(FLY_APP)

build:
	docker build .

create:
	fly apps create --org $(FLY_ORG) $(FLY_APP)
	fly scale vm -a $(FLY_APP) dedicated-cpu-8x

destroy:
	fly apps destroy -y $(FLY_APP)

logs:
	fly logs -a $(FLY_APP)
