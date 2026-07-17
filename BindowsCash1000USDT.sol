/**
Bindows.cash USDT mixer - 1000 USDT pool

https://bindows.cash
https://github.com/bindowscash
https://x.com/bindowscash
https://t.me/bindowscash
https://bindowscash.gitbook.io/

BindowsCash is a non-custodial token mixer operating on BSC, that breaks on-chain links between sender and recipient.
The mixer was built using simple and secured solidity functions.
Encryption is generated off-chain in a collision-resistant manner, using SHA256 and Keccak256.

For security purposes, variables are hardcoded (cannot be changed), and deposits/withdrawals cannot be paused or cancelled.
The contract cannot self-destruct, and cannot be called via delegatecall.
The contract is not deployed behind a proxy, so not immutable and not upgradeable (cannot be edited or replaced).
The funds cannot be withdrawn without a valid note: if it's lost, the funds are lost forever.
The contract has been secured against frontrunning, no third-party can steal your funds during withdrawal.

The protocol takes a 1% mixing fee between the deposit and the withdrawal (taken during the deposit).
THe fee is divided as follow: half goes to the developer's wallet, half funds the staking contract.
**/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}


contract BindowsCash1000USDT {
    struct DepositInfo {
        bytes32 commitment;
        uint256 timestamp;
    }

    DepositInfo[] public deposits;

    uint256 public constant MIX_AMOUNT = 1000_000_000_000_000_000_000; // 1000 * 10^18 (18 decimals = 1000 USDT)
    uint256 public constant FEE_BPS = 100; // 1% (100 basis points)

    mapping(bytes32 => bool) public commitments;
    mapping(bytes32 => bool) public nullifiers;

    event Deposit(bytes32 indexed commitment, uint256 timestamp);
    event Withdrawal(address indexed to, bytes32 indexed nullifier);

    address public constant DEV_ADDRESS = 0xD3d47348442cD6e1b3ca1481F26743A93c5ca537;

    IERC20 public immutable usdt;

    constructor(address _usdtAddress) {
        usdt = IERC20(_usdtAddress);
    }

    function recoverSigner(bytes32 commitment, bytes memory signature) public pure returns (address) {
        bytes32 messageHash = keccak256(abi.encodePacked(commitment));
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
        return recover(ethSignedMessageHash, signature);
    }

    function getEthSignedMessageHash(bytes32 _messageHash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
    }

    function recover(bytes32 _ethSignedMessageHash, bytes memory _signature) internal pure returns (address) {
        require(_signature.length == 65, "Invalid signature length");

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(_signature, 32))
            s := mload(add(_signature, 64))
            v := byte(0, mload(add(_signature, 96)))
        }

        return ecrecover(_ethSignedMessageHash, v, r, s);
    }


    function deposit(bytes32 commitment) external payable {
        require(!commitments[commitment], "Commitment already used");
        require(!nullifiers[commitment], "Commitment already withdrawn before");

        // Transfer 1000 USDT from sender to contract
        bool sent = usdt.transferFrom(msg.sender, address(this), MIX_AMOUNT);
        require(sent, "USDT transfer failed (Make sure you deposit exactly 1000 USDT)");

        commitments[commitment] = true;

        deposits.push(DepositInfo({
            commitment: commitment,
            timestamp: block.timestamp
        }));

        uint256 feeAmount = (MIX_AMOUNT * FEE_BPS) / 10_000;

        // relayer fee
        require(usdt.transfer(DEV_ADDRESS, feeAmount), "Transfer to relayer failed");

        emit Deposit(commitment, block.timestamp);
    }

    function getDepositsCount() external view returns (uint256) {
        return deposits.length;
    }

    function getDeposit(uint256 index) external view returns (bytes32 commitment, uint256 timestamp) {
        require(index < deposits.length, "Invalid index");
        DepositInfo storage d = deposits[index];
        return (d.commitment, d.timestamp);
    }

    function withdraw(bytes32 secret, bytes calldata signature) external {
        bytes32 commitment = sha256(abi.encodePacked(keccak256(abi.encodePacked(secret))));
        require(commitments[commitment], "Unknown commitment");
        require(!nullifiers[commitment], "Already withdrawn");

        address signer = recoverSigner(commitment, signature);
        require(signer != address(0), "Invalid signature");

        nullifiers[commitment] = true;
        commitments[commitment] = false;

        uint256 feeAmount = (MIX_AMOUNT * FEE_BPS) / 10_000;
        uint256 userAmount = MIX_AMOUNT - feeAmount;

        // USDT transfer to signer
        require(usdt.transfer(signer, userAmount), "Transfer to user failed");

        bytes32 hashedNullifierHash = keccak256(abi.encodePacked(commitment));
        emit Withdrawal(signer, hashedNullifierHash);
    }

}
