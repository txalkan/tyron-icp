.PHONY: all
all: deploy_ledger deploy

.PHONY: deploy_ledger
.SILENT: deploy_ledger
deploy_ledger:
	dfx deploy icrc1_ledger_syron --argument '(variant { Init = record { token_symbol = "SU$D"; token_name = "Syron US Dollar"; minting_account = record { owner = principal "kw4uv-ruwwf-3taa7-5zozj-vfuzw-txij5-s2esy-xxezt-bqmtk-xmgaf-xae" }; transfer_fee = 0; metadata = vec {}; feature_flags = opt record { icrc2 = true }; initial_balances = vec { record { record { owner = principal "kw4uv-ruwwf-3taa7-5zozj-vfuzw-txij5-s2esy-xxezt-bqmtk-xmgaf-xae"; }; 10_000_000_000; }; }; archive_options = record { num_blocks_to_archive = 1000; trigger_threshold = 2000; controller_id = principal "kw4uv-ruwwf-3taa7-5zozj-vfuzw-txij5-s2esy-xxezt-bqmtk-xmgaf-xae"; cycles_for_archive_creation = opt 10000000000000 }}})'

.PHONY: deploy
.SILENT: deploy
deploy:
	dfx deploy basic_bitcoin_syron --argument '(variant { regtest }, variant { Init = record { mode = variant { ReadOnly }; btc_network = variant { Regtest }; ledger_id = principal "$(LEDGER_ID)"; ecdsa_key_name = "key_1"; min_confirmations = opt 72; retrieve_btc_min_amount = 100_000; max_time_in_queue_nanos = 600_000_000_000 } })'

.PHONY: clean
.SILENT: clean
clean:
	rm -rf .dfx
	cargo clean
