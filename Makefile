.PHONY: all
all: deploy

.PHONY: deploy
.SILENT: deploy
deploy:
	dfx deploy basic_bitcoin_syron --argument '(variant { regtest }, variant { Init = record { mode = variant { ReadOnly }; btc_network = variant { Regtest }; ledger_id = principal "mxzaz-hqaaa-aaaar-qaada-cai"; ecdsa_key_name = "key_1"; min_confirmations = opt 72; retrieve_btc_min_amount = 100_000; max_time_in_queue_nanos = 600_000_000_000 } })'
.PHONY: clean
.SILENT: clean
clean:
	rm -rf .dfx
	cargo clean
