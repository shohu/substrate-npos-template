#!/bin/bash
SELF_PATH=$(cd $(dirname $0); pwd)
BASE_PAHT="$(dirname "$SELF_PATH")"
LOG_DIR=$BASE_PAHT/logs

launch () {
    nohup $BASE_PAHT/target/release/node-template --chain testnet.json -d data/validator1 --name validator1 --in-peers 256 --validator --ws-external --rpc-external --rpc-cors all --rpc-methods=unsafe --node-key 0x74a8cfbadb5d2b0178ec124791bfa8346ac3550a4f689923c806428090055277 > $LOG_DIR/v1.log 2>&1 &
    nohup $BASE_PAHT/target/release/node-template --chain testnet.json -d data/validator2 --name validator2 --validator --port 30334 --ws-port 9946 --rpc-port 9934 --ws-external --rpc-external --rpc-cors all --rpc-methods=unsafe > $LOG_DIR/v2.log 2>&1 &
    nohup $BASE_PAHT/target/release/node-template --chain testnet.json -d data/validator3 --name validator3 --validator --port 30335 --ws-port 9947 --rpc-port 9935 --ws-external --rpc-external --rpc-cors all --rpc-methods=unsafe > $LOG_DIR/v3.log 2>&1 &
    nohup $BASE_PAHT/target/release/node-template --chain testnet.json -d data/validator4 --name validator4 --validator --port 30336 --ws-port 9948 --rpc-port 9936 --ws-external --rpc-external --rpc-cors all --rpc-methods=unsafe > $LOG_DIR/v4.log 2>&1 &
}

stop-all () {
    pkill -f node-template
    sleep 1
}

echo "Stop validators ...."
stop-all

# $BASE_PAHT/target/release/node-template --chain testnet.json -d data/validator1 --name validator1 --in-peers 256 --validator --ws-external --rpc-external --rpc-cors all --rpc-methods=unsafe --node-key 0x74a8cfbadb5d2b0178ec124791bfa8346ac3550a4f689923c806428090055277 > $LOG_DIR/v1.log 2>&1 &
# exit

echo "Delete validator data ...."
rm -rf $BASE_PAHT/data/validator*/**

echo "Launch validators ...."
launch
sleep 20

echo "Set session keys ...."
cd $BASE_PAHT/scripts/session_keys || exit
sh run.sh
cd $BASE_PAHT || exit

echo "Stop validators ...."
stop-all
# launch

echo "Finish ...."
