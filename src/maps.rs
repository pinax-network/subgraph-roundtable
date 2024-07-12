use substreams::errors::Error;
use substreams::pb::substreams::Clock;
use substreams_entity_change::pb::entity::EntityChanges;
use substreams_entity_change::tables::Tables;
use substreams_ethereum::pb::eth::v2::Block;

use crate::utils::{bytes_to_hex, timestamp_to_date};

#[substreams::handlers::map]
pub fn graph_out(clock: Clock, block: Block) -> Result<EntityChanges, Error> {
    let mut tables = Tables::new();
    let header = block.header.unwrap();
    let timestamp = clock.timestamp.unwrap();

    tables
        .create_row("blocks", &clock.id)
        .set("timestamp", timestamp.to_string())
        .set_bigint("number", &clock.number.to_string())
        .set("hash", format!("0x{}", clock.id))
        .set("parent_hash", bytes_to_hex(header.parent_hash))
        .set("date", timestamp_to_date(timestamp.to_string().as_str()))
        .set_bigint("nonce", &header.nonce.to_string())
        .set("ommers_hash", bytes_to_hex(header.uncle_hash))
        .set("logs_bloom", bytes_to_hex(header.logs_bloom))
        .set("transactions_root", bytes_to_hex(header.transactions_root))
        .set("state_root", bytes_to_hex(header.state_root))
        .set("receipts_root", bytes_to_hex(header.receipt_root))
        .set("miner", bytes_to_hex(header.coinbase))
        .set_bigint("difficulty", &header.difficulty.unwrap_or_default().with_decimal(0).to_string())
        .set_bigint("total_difficulty", &header.total_difficulty.unwrap_or_default().with_decimal(0).to_string())
        .set_bigint("size", &block.size.to_string())
        .set("mix_hash", bytes_to_hex(header.mix_hash))
        .set("extra_data", bytes_to_hex(header.extra_data))
        .set_bigint("gas_limit", &header.gas_limit.to_string())
        .set_bigint("gas_used", &header.gas_used.to_string())
        .set_bigint("blob_gas_used", &header.blob_gas_used.unwrap_or_default().to_string())
        .set_bigint("transaction_count", &block.transaction_traces.len().to_string())
        .set_bigint("base_fee_per_gas", &header.base_fee_per_gas.unwrap_or_default().with_decimal(0).to_string())
        .set("parent_beacon_root", bytes_to_hex(header.parent_beacon_root));

    Ok(tables.to_entity_changes())
}
