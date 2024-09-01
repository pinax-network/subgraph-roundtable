-------------------------------------------------
-- Meta tables to store Substreams information --
-------------------------------------------------
CREATE TABLE IF NOT EXISTS cursors
(
    id        String,
    cursor    String,
    block_num Int64,
    block_id  String
)
    ENGINE = ReplacingMergeTree()
        PRIMARY KEY (id)
        ORDER BY (id);

CREATE TABLE IF NOT EXISTS blocks
(
    -- clock --
    block_time                              DateTime64(3, 'UTC'),
    block_number                            UInt64,
    block_date                              Date,
    block_hash                              String,

    -- header --
    previous                                String,
    producer                                String,
    confirmed                               UInt32,
    schedule_version                        UInt32,

    -- clock --
    version                                 UInt32,
    producer_signature                      String COMMENT 'Signature',
    dpos_proposed_irreversible_blocknum     UInt32,
    dpos_irreversible_blocknum              UInt32,

    -- block roots --
    transaction_mroot                       String,
    action_mroot                            String,
    -- blockroot_merkle_active_nodes           Array(String) COMMENT 'A blockroot Merkle tree uses hashes to verify blockchain data integrity. Leaf nodes hash data blocks, non-leaf nodes hash child nodes. The root hash efficiently verifies all data.',
    blockroot_merkle_node_count             UInt32,

    -- counters --
    size                                    UInt64 COMMENT 'Block size estimate in bytes',
    total_transactions                      UInt64,
    successful_transactions                 UInt64,
    failed_transactions                     UInt64,
    total_actions                           UInt64,
    total_db_ops                            UInt64,
)
    ENGINE = ReplacingMergeTree()
        PRIMARY KEY (block_date, block_number)
        ORDER BY (block_date, block_number, block_hash)
        COMMENT 'Antelope block header';

CREATE TABLE IF NOT EXISTS transactions
(
    -- clock --
    block_time                  DateTime64(3, 'UTC'),
    block_number                UInt64,
    block_hash                  String,
    block_date                  Date,

    -- transaction --
    hash                        String,
    `index`                     UInt64,
    elapsed                     Int64,
    net_usage                   UInt64,
    scheduled                   Bool,

    -- header --
    cpu_usage_micro_seconds     UInt32,
    net_usage_words             UInt32,
    status                      LowCardinality(String) COMMENT 'Status',
    status_code                 UInt8,
    success                     Bool,

    -- block roots --
    transaction_mroot           String,
)
    ENGINE = ReplacingMergeTree()
        PRIMARY KEY (hash)
        ORDER BY (hash)
        COMMENT 'Antelope transactions';

CREATE TABLE IF NOT EXISTS actions
(
    -- clock --
    block_time                  DateTime64(3, 'UTC'),
    block_number                UInt64,
    block_hash                  String,
    block_date                  Date,

    -- transaction --
    tx_hash                     String,
    tx_index                    UInt64,
    tx_status                   LowCardinality(String),
    tx_status_code              UInt8,
    tx_success                  Bool,

    -- receipt --
    abi_sequence                UInt64,
    code_sequence               UInt64,
    digest                      String,
    global_sequence             UInt64,
    receipt_receiver            String,
    recv_sequence               UInt64,

    -- action --
    account                     String,
    name                        String,
    json_data                   String COMMENT 'JSON',
    raw_data                    String COMMENT 'Hex',

    -- trace --
    action_ordinal                                  UInt32 COMMENT 'Action Ordinal',
    receiver                                        String,
    context_free                                    Bool,
    elapsed                                         Int64,
    console                                         String,
    raw_return_value                                String,
    json_return_value                               String,
    creator_action_ordinal                          UInt32,
    closest_unnotified_ancestor_action_ordinal      UInt32,
    execution_index                                 UInt32,

    -- block roots --
    action_mroot                                    String,
)
    ENGINE = ReplacingMergeTree()
        PRIMARY KEY (tx_hash, action_ordinal)
        ORDER BY (tx_hash, action_ordinal)
        COMMENT 'Antelope actions';

CREATE TABLE IF NOT EXISTS db_ops
(
    -- clock --
    block_time                  DateTime64(3, 'UTC'),
    block_number                UInt64,
    block_hash                  String,
    block_date                  Date,

    -- transaction --
    tx_hash                     String,
    tx_index                    UInt64,
    tx_status                   LowCardinality(String),
    tx_status_code              UInt8,
    tx_success                  Bool,

    -- database operation --
    `index`                     UInt32,
    operation                   LowCardinality(String) COMMENT 'Operation',
    operation_code              UInt8,
    action_index                UInt32,
    code                        String,
    scope                       String,
    table_name                  String,
    primary_key                 String,
    old_payer                   String,
    new_payer                   String,
    old_data                    String,
    new_data                    String,
    old_data_json               String,
    new_data_json               String,
)
    ENGINE = ReplacingMergeTree()
        PRIMARY KEY (tx_hash, `index`)
        ORDER BY (tx_hash, `index`)
        COMMENT 'Antelope database operations';

CREATE TABLE IF NOT EXISTS receivers
(
    -- clock --
    block_time                  DateTime64(3, 'UTC'),
    block_number                UInt64,
    block_hash                  String,
    block_date                  Date,

    -- transaction --
    tx_hash                 String,

    -- action --
    action_ordinal          UInt32,

    -- receiver --
    receiver                String
)
    ENGINE = ReplacingMergeTree()
        PRIMARY KEY (tx_hash, action_ordinal, receiver)
        ORDER BY (tx_hash, action_ordinal, receiver)
        COMMENT 'Antelope action receivers';

CREATE TABLE IF NOT EXISTS authorizations
(
    -- clock --
    block_time                  DateTime64(3, 'UTC'),
    block_number                UInt64,
    block_hash                  String,
    block_date                  Date,

    -- transaction --
    tx_hash                 String,

    -- action --
    action_ordinal          UInt32,

    -- authorization --
    actor                   String,
    permission              LowCardinality(String)
)
    ENGINE = ReplacingMergeTree()
        PRIMARY KEY (tx_hash, action_ordinal, actor, permission)
        ORDER BY (tx_hash, action_ordinal, actor, permission)
        COMMENT 'Antelope action authorizations';

-- MV TABLE::receivers (tx_hash) --
CREATE TABLE IF NOT EXISTS receivers_by_receiver
(
    -- transaction --
    tx_hash                 String,

    -- action --
    action_ordinal          UInt32,

    -- receiver --
    receiver                String
)
    ENGINE = ReplacingMergeTree()
        ORDER BY (receiver, tx_hash, action_ordinal);

CREATE MATERIALIZED VIEW IF NOT EXISTS receivers_by_receiver_mv
    TO receivers_by_receiver
AS
SELECT tx_hash,
       action_ordinal,
       receiver
FROM receivers;

-- MV TABLE::authorizations (tx_hash) --
CREATE TABLE IF NOT EXISTS authorizations_by_actor
(
    -- transaction --
    tx_hash                 String,

    -- action --
    action_ordinal          UInt32,

    -- authorization --
    actor                   String,
    permission              LowCardinality(String)
)
    ENGINE = ReplacingMergeTree()
        ORDER BY (actor, permission, tx_hash, action_ordinal);

CREATE MATERIALIZED VIEW IF NOT EXISTS authorizations_by_actor_mv
    TO authorizations_by_actor
AS
SELECT tx_hash,
       action_ordinal,
       actor,
       permission
FROM authorizations;