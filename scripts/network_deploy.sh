#!/bin/bash

PUBLIC_KEY="principal \"$( \
    dfx identity get-principal
)\""

# dfx canister --network ic create icpunks
# dfx canister --network ic create icpunks_storage
# dfx canister --network ic create icpunks_assets

dfx build --network ic icpunks
dfx build --network ic icpunks_storage
# # dfx build --network ic icpunks_assets

eval dfx canister --network ic install icpunks --argument="'(\"ICats\", \"ICA\", 10000, $PUBLIC_KEY)'" -m reinstall
eval dfx canister --network ic install icpunks_storage --argument="'($PUBLIC_KEY)'" -m reinstall
# # # # eval dfx canister --network ic install icpunks_assets -m upgrade

ICPUNKSID=$(dfx canister --network ic id icpunks)
STOREID=$(dfx canister --network ic id icpunks_storage)

ICPUNKSID="principal \"$ICPUNKSID\""
STOREID="principal \"$STOREID\""

eval dfx canister --network ic call icpunks set_storage_canister "'($STOREID)'"
eval dfx canister --network ic call icpunks_storage setTokenCanisterId "'($ICPUNKSID)'"
eval dfx canister --network ic call icpunks add_genesis_record

echo "Preparation complete"
eval dfx canister --network ic call icpunks set_owner "'(principal \"xm4y3-54lfy-pkijk-3gpzg-gsm3l-yr7al-i5ai7-odpf7-l2pmv-222rl-7qe\")'"
