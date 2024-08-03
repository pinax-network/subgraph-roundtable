use substreams::errors::Error;
use substreams::pb::substreams::Clock;
use substreams_database_change::pb::database::DatabaseChanges;
use substreams_ethereum::pb::eth::v2::Block;

use crate::balance_changes::insert_block_balance_changes;
use crate::blocks::insert_blocks;
use crate::transactions::insert_transactions;

#[substreams::handlers::map]
pub fn ch_out(clock: Clock, block: Block) -> Result<DatabaseChanges, Error> {
    let mut tables: DatabaseChanges = DatabaseChanges::default();
    insert_blocks(&mut tables, &clock, &block);
    insert_block_balance_changes(&mut tables, &clock, &block.balance_changes);
    insert_transactions(&mut tables, &clock, &block.transaction_traces);

    Ok(tables)
}

// TO-DO: Implement the `graph_out` function using EntityChanges
#[substreams::handlers::map]
pub fn graph_out(clock: Clock, block: Block) -> Result<DatabaseChanges, Error> {
    let mut tables: DatabaseChanges = DatabaseChanges::default();
    insert_blocks(&mut tables, &clock, &block);
    // TO-DO: Convert DatabaseChanges to EntityChanges
    Ok(tables)
}
