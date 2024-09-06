use substreams::{pb::substreams::Clock, Hex};
use substreams_antelope::pb::{ActionTrace, TransactionTrace};
use substreams_entity_change::tables::Tables;

use crate::{keys::action_key, utils::is_match};

use super::authorizations::insert_authorization;

// https://github.com/pinax-network/firehose-antelope/blob/534ca5bf2aeda67e8ef07a1af8fc8e0fe46473ee/proto/sf/antelope/type/v1/type.proto#L525
pub fn insert_action(params: &String, tables: &mut Tables, clock: &Clock, trace: &ActionTrace, transaction: &TransactionTrace) {
    // trace
    let index = trace.execution_index;
	let action = trace.action.clone().unwrap_or_default();
    let receiver = &trace.receiver;

    // action data
    let account = action.account;
    let name = action.name;
    let json_data = action.json_data;
    let raw_data = Hex::encode(&action.raw_data.to_vec());
    let is_notify = account.ne(receiver);

    // transaction
    let tx_hash = &transaction.id;

    // TABLE::Action
    let key = action_key(tx_hash, &index);

    if is_match(Vec::from(["table:Action"]), params) {
        tables
            .create_row("Action", key)
            // pointers
            .set("transaction", tx_hash)
            .set("block", &clock.id)

            // trace
            .set_bigint("index", &index.to_string())
            .set("receiver", receiver)
            .set("isNotify", is_notify)

            // action
            .set("account", account)
            .set("name", name)
            .set("jsonData", json_data)
            .set("rawData", raw_data)
            ;
    }

    // TABLE::authorizations
    for authorization in action.authorization.iter() {
        insert_authorization(params, tables, trace, transaction, authorization);
    };
}