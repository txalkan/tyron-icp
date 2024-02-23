.PHONY: all
all: ledger deploy vault susd reinstall

.PHONY: ledger
.SILENT: ledger
ledger:
	dfx deploy icrc1_ledger_syron --argument '(variant { Init = record { token_symbol = "SU$D"; token_name = "Syron US Dollar"; minting_account = record { owner = principal "kw4uv-ruwwf-3taa7-5zozj-vfuzw-txij5-s2esy-xxezt-bqmtk-xmgaf-xae" }; transfer_fee = 0; metadata = vec {}; feature_flags = opt record { icrc2 = true }; initial_balances = vec { record { record { owner = principal "kw4uv-ruwwf-3taa7-5zozj-vfuzw-txij5-s2esy-xxezt-bqmtk-xmgaf-xae"; }; 10_000_000_000; }; }; archive_options = record { num_blocks_to_archive = 1000; trigger_threshold = 2000; controller_id = principal "kw4uv-ruwwf-3taa7-5zozj-vfuzw-txij5-s2esy-xxezt-bqmtk-xmgaf-xae"; cycles_for_archive_creation = opt 10000000000000 }}})'

.PHONY: deploy
.SILENT: deploy
deploy:
	dfx deploy basic_bitcoin_syron --argument '(variant { regtest }, variant { Init = record { mode = variant { GeneralAvailability }; btc_network = variant { Regtest }; ledger_id = principal "$(LEDGER)"; ecdsa_key_name = "dfx_test_key"; min_confirmations = opt 1; retrieve_btc_min_amount = 100_000; max_time_in_queue_nanos = 600_000_000_000 } })'

# ----
# export PRINCIPAL=$(dfx identity get-principal)
# ----
.PHONY: vault
.SILENT: vault
vault:
	#dfx canister call basic_bitcoin_syron get_btc_address "(record { owner = opt principal \"$(PRINCIPAL)\"; subaccount = null;})"
	# dfx canister call basic_bitcoin_syron get_btc_address "(record { owner = opt principal \"$(PRINCIPAL)\"})"
	# dfx canister call basic_bitcoin_syron get_btc_address "(record { subaccount=null;})"

	# Add SSI
	# dfx canister call basic_bitcoin_syron get_btc_address "(record { owner = opt principal \"$(PRINCIPAL)\"; subaccount = null; ssi=\"$(SSI)\";})"
	dfx canister call basic_bitcoin_syron get_btc_address "(record { ssi=\"$(SSI)\";})"

.PHONY: susd
.SILENT: susd
susd:
	dfx canister call basic_bitcoin_syron update_balance "(record { ssi=\"$(SSI)\";})"

.PHONY: reinstall
.SILENT: reinstall
reinstall:
	dfx canister install basic_bitcoin_syron --argument '(variant { regtest }, variant { Init = record { mode = variant { GeneralAvailability }; btc_network = variant { Regtest }; ledger_id = principal "$(LEDGER)"; ecdsa_key_name = "dfx_test_key"; min_confirmations = opt 1; retrieve_btc_min_amount = 100_000; max_time_in_queue_nanos = 600_000_000_000 } })' --mode=reinstall

.PHONY: clean
.SILENT: clean
clean:
	rm -rf .dfx
	cargo clean
