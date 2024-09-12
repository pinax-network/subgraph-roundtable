.PHONY: all
all:
	make build

.PHONY: build
build:
	graph build

.PHONY: deploy
deploy:
	graph build
	graph create --node http://localhost:8020 roundtable
	graph deploy --node=http://localhost:8020 roundtable

.PHONY: publish
publish:
	graph build
	graph publish --subgraph-id BEPBdCakjSNmQFLy8RiSYpjnsKYN58VxJ41uz6qQHy2p

.PHONY: gui
gui:
	substreams gui ./substreams/antelope-transactions-v0.4.2.spkg -e eos.substreams.pinax.network:443 graph_out -s 387995902 --production-mode --params "graph_out=code:bbsdailyrwrd || code:dwebregistry || code:bbseosbridge || code:bbsbbsbbseos || code:bbsengagemnt || code:deweb.eosn"