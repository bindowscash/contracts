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

The protocol takes a 1% mixing fee, funding the staking pool.

The full source code of BindowsCash contracts is available in the contracts files. You will also find the official deployments addresses on BSC.

## BSC Mainnet
### BNB

    0.01 BNB testpool: 0xE75eB24177CeabAfA957ECd117066ed71C500b44
    0.1 BNB pool: 0x53830CC903C4bCeF34d94CEFCbbc18341d90EcC6
    1 BNB pool: 0xb9757850Ab6F8c39B55752790ABF77Ed5faD463d
    10 BNB pool: 0x26494d081c33019965effBfeF3BD5B963e635B09
    100 BNB pool: 0x39E84646FC3653b255568e11B44F8e80eda5043D

### USDT

    1 USDT testpool: 0x5fCeC66b63Cc8e9d38E8183fad396656bb687B00
    10 USDT pool: 0x7e95a6b17d9F84E59a703C7e4ECD3ab1b466e61F
    100 USDT pool: 0x567703b577C4f7aa4cC9680d968Ca22c1706f2b0
    1000 USDT pool: 0x55B1B469a993bd5D7F50B14b78F83bd275E788C3
    10000 USDT pool: 0xFED0B9bbAad31fbc3f0112225749494d97abE464


### BINDOWS

    1000 BINDOWS pool: 0xcAd9C0e3478B6126ACDde94950304f0Ec137dd3A
    10000 BINDOWS pool: 0xCe834ee7bB6A7cb5BE89743997544372dC909CD7
    100000 BINDOWS pool: 0x05c368D43A11B0D06E6edD4D4D89Ca17D52A84aF
    1000000 BINDOWS pool: 0xBbBbbf2B7a6C3e6600727417b2483A9E3b3098f7
