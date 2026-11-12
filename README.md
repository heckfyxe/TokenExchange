# Token Exchange

My solution to the [Token Exchange mini project](https://rareskills.io/learn-solidity/mini-project) from the
RareSkills [Learn Solidity](https://rareskills.io/learn-solidity) course.

Two ERC-20 tokens:

- **SkillsCoin (SKL)**: anyone can mint it.
- **RareCoin (RARE)**: the only way to get it is to trade SkillsCoin for it, 1:1. The traded SkillsCoin stays in the
  RareCoin contract.

## Contracts

| File | What it does |
| --- | --- |
| [`src/ERC20.sol`](src/ERC20.sol) | A minimal ERC-20 base: balances, allowances, `transfer`, `approve`, `transferFrom` |
| [`src/SkillsCoin.sol`](src/SkillsCoin.sol) | `mint(amount)` mints SkillsCoin to the caller |
| [`src/RareCoin.sol`](src/RareCoin.sol) | Takes the SkillsCoin address in its constructor; `trade(amount)` pulls `amount` SkillsCoin from the caller with a low-level `transferFrom` call and mints the same amount of RareCoin |

## Workflow

1. `SkillsCoin.mint(amount)`: mint SkillsCoin to yourself.
2. `SkillsCoin.approve(rareCoinAddress, amount)`: allow RareCoin to take your SkillsCoin.
3. `RareCoin.trade(amount)`: RareCoin calls `SkillsCoin.transferFrom(you, address(this), amount)` and mints you
   `amount` RareCoin.
4. `RareCoin.balanceOf(you)` now returns `amount`, and `SkillsCoin.balanceOf(rareCoinAddress)` holds what you traded.

## Build

Requires [Foundry](https://getfoundry.sh/).

```shell
forge build
```

## Try it on a local chain

Start a local node in one terminal:

```shell
anvil
```

In another terminal, use one of the accounts anvil prints:

```shell
RPC=http://127.0.0.1:8545
KEY=<private key from anvil>
ME=<address of that key>

# deploy
SKILLS=$(forge create src/SkillsCoin.sol:SkillsCoin --rpc-url $RPC --private-key $KEY --broadcast | awk '/Deployed to/ {print $3}')
RARE=$(forge create src/RareCoin.sol:RareCoin --rpc-url $RPC --private-key $KEY --broadcast --constructor-args $SKILLS | awk '/Deployed to/ {print $3}')

# mint, approve, trade
cast send $SKILLS "mint(uint256)" 100 --rpc-url $RPC --private-key $KEY
cast send $SKILLS "approve(address,uint256)" $RARE 100 --rpc-url $RPC --private-key $KEY
cast send $RARE "trade(uint256)" 100 --rpc-url $RPC --private-key $KEY

# check
cast call $RARE "balanceOf(address)(uint256)" $ME --rpc-url $RPC      # 100
cast call $SKILLS "balanceOf(address)(uint256)" $RARE --rpc-url $RPC  # 100
```

The course suggests [Remix](https://remix.ethereum.org/) instead; the same steps work there.
