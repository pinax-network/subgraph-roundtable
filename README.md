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
- **Query URL format**: `{base_url}`/api/`{api-key}`/subgraphs/id/`{subgraph_id}`

| Chain | Subgraph ID |
| ----- | ----------- |
| EOS   | [`BEPBdCakjSNmQFLy8RiSYpjnsKYN58VxJ41uz6qQHy2p`](https://thegraph.com/explorer/subgraphs/BEPBdCakjSNmQFLy8RiSYpjnsKYN58VxJ41uz6qQHy2p?view=Query&chain=arbitrum-one) |

## GraphQL

```graphql
{
  actions(
    orderBy: block__number
    orderDirection: desc
  ) {
    block{
      number
      time
    }
    transaction {
      id
    }
    account
    name
    jsonData
    dbOps {
      code
      tableName
      primaryKey
      newDataJson
    }
  }
}
```
