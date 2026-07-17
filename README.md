# BindowsCash contracts

BindowsCash mixers were built using simple and secured solidity functions.
Encryption is generated off-chain in a collision-resistant manner, using a combination of SHA256 and Keccak256. We do not use ZKSNARK/STARK nor MerkleTree configuration, but the multiple-layers encryption combined to a strong anonymity set (high amount of deposits) still makes it a good privacy tool for end-users.

Security features of the contracts:
- Variables are hardcoded (cannot be changed)
- Deposits/withdrawals cannot be paused or cancelled by a third-party
- The contracts cannot self-destruct, and cannot be called via a delegatecall.
- The contracts are not deployed behind a proxy, so they are not immutable and not upgradeable.
- The funds cannot be withdrawn without a valid note: if the note is lost, the associated funds are lost forever.
- The contract has been secured against frontrunning, no third-party can steal your funds during withdrawal.
- There is no expiration on deposits. Your deposit can lay in the contract as long as you want.
- All the contracts are public and verified on the blockchains, ensuring transparency and security.

The protocol takes a 1% mixing fee, funding the srelayer costs and development, and for the Bindows mixing pools, half of the fee funds the staking pool.

The full source code of BindowsCash contracts is available in the contracts files. You will also find the official deployments addresses on BSC.

## BSC Mainnet
### BNB

    0.0001 BNB testpool: 0xC4f38025C4565a817A224b39a8Fa04bC4317Df9d
    0.001 BNB pool: 0x93f4a60ea99F20376bF6F9Cf0c17cb1c6d3634ff
    0.01 BNB pool: 0x1094F7E01F15Cf05BB1E02992dd5080fe9cF9374
    0.1 BNB pool: 0x19686B2cafa1960d4d1Bd4e2945F336F1b9856E8
    1 BNB pool: 0x072Ea8fD3051ed890f0FA3Dcd7d878cDF1b429BA

### USDT

    0.1 USDT testpool: 0x13970bEE917beC71eEC3751C1A9b0C558DDc022f
    1 USDT pool: 0x37352CE527b9382755B05E4B7441A334Ee2cBa80
    10 USDT pool: 0x5fb9C7c12B577de17Ad0A82f219A38a5Bdc873Ae
    100 USDT pool: 0x38Ab990Bae4EBf8a23c64ee7b9c051a67d5eC235
    1000 USDT pool: 0xD3E3f8480b666F686A11C86EDC1BAD87E3509365


### BINDOWS

    1000 BINDOWS pool: TBA
    10000 BINDOWS pool: TBA
    100000 BINDOWS pool: TBA
    1000000 BINDOWS pool: TBA
