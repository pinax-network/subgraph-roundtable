.PHONY: all
all:
	make build
	make deploy

.PHONY: build
build:
	graph build

.PHONY: deploy
deploy:
	graph deploy --node=http://localhost:8020 roundtable

.PHONY: publish
publish:
	graph build
	graph publish --subgraph-id 4bAe7NA8b6J14ZfZr3TXfzzjjSoGECTFuqv7CwnK1zzg

.PHONY: gui
gui:
	substreams gui antelope-transactions-v0.3.7.spkg -e eos.substreams.pinax.network:443 graph_out -s 387995902 --production-mode --params "graph_out=(code:bbsdailyrwrd || code:dwebregistry||code:bbseosbridge || code:bbsbbsbbseos || code:bbsengagemnt || code:deweb.eosn) && (notif:false)"