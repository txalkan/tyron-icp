.PHONY: all
all: ledgers deploy vault susd reinstall

# ----
# export NET=ic
# export PRINCIPAL=$(dfx identity get-principal)
# ----
.PHONY: ledgers
.SILENT: ledgers
ledgers:
	dfx deploy --network="$(NET)" icrc1_ledger_syron_btc --argument '(variant { Init = record { token_symbol = "BTC"; token_name = "BTC Syron Ledger"; minting_account = record { owner = principal "$(PRINCIPAL)" }; transfer_fee = 0; metadata = vec {}; feature_flags = opt record { icrc2 = true }; initial_balances = vec { record { record { owner = principal "$(PRINCIPAL)"; }; 2_100_000_000_000_000; }; }; archive_options = record { num_blocks_to_archive = 1000; trigger_threshold = 2000; controller_id = principal "$(PRINCIPAL)"; cycles_for_archive_creation = opt 10000000000000 }}})'\
	&& dfx deploy --network="$(NET)" icrc1_ledger_syron_susd --argument '(variant { Init = record { token_symbol = "SU$D"; token_name = "Syron US Dollar"; minting_account = record { owner = principal "$(PRINCIPAL)" }; transfer_fee = 0; metadata = vec {}; feature_flags = opt record { icrc2 = true }; initial_balances = vec { record { record { owner = principal "$(PRINCIPAL)"; }; 10_000_000_000_000_000_000; }; }; archive_options = record { num_blocks_to_archive = 1000; trigger_threshold = 2000; controller_id = principal "$(PRINCIPAL)"; cycles_for_archive_creation = opt 10000000000000 }}})'

# ----
# export BTC_LEDGER=$(dfx canister id --ic icrc1_ledger_syron_btc) SUSD_LEDGER=$(dfx canister id --ic icrc1_ledger_syron_susd) SSI=tb1pjnr5curwpqcxhyxjfcqmya3ms48s7ca7erd6uxwx6dp3svunq2wsq4me33
# ----

.PHONY: deploy
.SILENT: deploy
deploy:
	dfx deploy --network="$(NET)" basic_bitcoin_syron --argument '(variant { testnet }, variant { Init = record { mode = variant { GeneralAvailability }; btc_network = variant { Testnet }; ledger_id = principal "$(BTC_LEDGER)"; susd_id = principal "$(SUSD_LEDGER)"; ecdsa_key_name = "test_key_1"; min_confirmations = opt 1; retrieve_btc_min_amount = 100_000; max_time_in_queue_nanos = 600_000_000_000 } })'

.PHONY: vault
.SILENT: vault
vault:
	#dfx canister call basic_bitcoin_syron get_btc_address "(record { owner = opt principal \"$(PRINCIPAL)\"; subaccount = null;})"
	# dfx canister call basic_bitcoin_syron get_btc_address "(record { owner = opt principal \"$(PRINCIPAL)\"})"
	# dfx canister call basic_bitcoin_syron get_btc_address "(record { subaccount=null;})"

	# Add SSI
	# dfx canister call basic_bitcoin_syron get_btc_address "(record { owner = opt principal \"$(PRINCIPAL)\"; subaccount = null; ssi=\"$(SSI)\";})"
	dfx canister --network="$(NET)" call basic_bitcoin_syron get_btc_address "(record { ssi=\"$(SSI)\";})"

.PHONY: susd
.SILENT: susd
susd:
	dfx canister --network="$(NET)" call basic_bitcoin_syron update_balance "(record { ssi=\"$(SSI)\";})"

# dfx build --ic
.PHONY: reinstall
.SILENT: reinstall
reinstall:
	dfx canister --network="$(NET)" install --mode=reinstall basic_bitcoin_syron --argument '(variant { testnet }, variant { Init = record { mode = variant { GeneralAvailability }; btc_network = variant { Testnet }; ledger_id = principal "$(BTC_LEDGER)"; susd_id = principal "$(SUSD_LEDGER)"; ecdsa_key_name = "test_key_1"; min_confirmations = opt 1; retrieve_btc_min_amount = 100_000; max_time_in_queue_nanos = 600_000_000_000 } })'
	# dfx canister --network="$(NET)" install --all --mode=upgrade basic_bitcoin_syron

.PHONY: clean
.SILENT: clean
clean:
	rm -rf .dfx
	cargo clean
