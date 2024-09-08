.PHONY: all
all:
	make build
	make create
	make deploy

.PHONY: build
build:
	graph build

.PHONY: deploy
deploy:
	graph deploy --node=http://localhost:8020 roundtable

.PHONY: create
create:
	graph create --node http://localhost:8020 roundtable

.PHONY: publish
publish:
	graph build
	graph publish --subgraph-id BEPBdCakjSNmQFLy8RiSYpjnsKYN58VxJ41uz6qQHy2p

.PHONY: gui
gui:
	substreams gui antelope-transactions-v0.3.7.spkg -e eos.substreams.pinax.network:443 graph_out -s 387995902 --production-mode --params "graph_out=(code:bbsdailyrwrd || code:dwebregistry||code:bbseosbridge || code:bbsbbsbbseos || code:bbsengagemnt || code:deweb.eosn) && (notif:false)"