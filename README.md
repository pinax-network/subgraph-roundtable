# Subgraph: `Roundtable`

> Transactions, Decoded Actions & Database Operations
>
> [`sf.antelope.type.v1.Block`](https://buf.build/pinax/firehose-antelope/docs/main:sf.antelope.type.v1)

- [x] **Blocks**
- [x] **Transactions**
- [x] **Actions**
  - [x] **Authorization**
  - [x] **Receiver**
- [x] **DatabaseOperations**

## Smart Contracts

- `bbsdailyrwrd`
- `dwebregistry`
- `bbseosbridge`
- `bbsbbsbbseos`
- `bbsengagemnt`
- `deweb.eosn`

## Subgraph

- **API Key**: https://thegraph.com/studio/apikeys/
- **Base URL**: https://gateway.thegraph.com/api
- **Subgraph ID**: `BEPBdCakjSNmQFLy8RiSYpjnsKYN58VxJ41uz6qQHy2p`
- **Subgraph NFT**: `68755974302284623006443583448037966151301717749760121271985211462386991549177`
- **Query URL format**: `{base_url}`/api/`{api-key}`/subgraphs/id/`{subgraph_id}`

## GraphQL

```graphql
{
  actions(
    orderBy: globalSequence
    orderDirection: asc
    first:20
    where:{
      name:"ledgerprint"
      globalSequence_gt:361417757518
    }
  ) {
    block{
      number
      timestamp
    }
    transaction {
      id
    }
    account
    name
    jsonData
    globalSequence
    receiver
    dbOps {
      code
      tableName
      primaryKey
      newDataJson
    }
  }
}
```

## Subgraph deployment

```bash
$ ./shell cli
graph indexer rules prepare --network arbitrum-one QmWiivncZD2HHRKymf4ArQYQr7jRhZ6kWw2pFxD3nB8p8m
graph indexer allocations create QmWiivncZD2HHRKymf4ArQYQr7jRhZ6kWw2pFxD3nB8p8m arbitrum-one 100
```