//SPDX-License-Identifier: UNLICENSED
import "hardhat/console.sol";

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.0;

// This is the main building block for smart contracts.
contract Token {
    // Some string type variables to identify the token.
    string public name = "My Hardhat Token";
    string public symbol = "MHT";

    // The fixed amount of tokens, stored in an unsigned integer type variable.
    uint256 public totalSupply = 1000000;

    // An address type variable is used to store ethereum accounts.
    address public owner;

    // A mapping is a key/value map. Here we store each account's balance.
    mapping(address => uint256) balances;
    mapping(address => uint256) deposits;
    mapping(address => uint256) public depositTimestamp;
    uint256 public constant INTEREST_RATE = 2; // 2%
    uint public constant BLOCK_DURATION = 5 minutes;

    event Deposit(address indexed account, uint256 amount);
    event Withdrawal(address indexed account, uint256 amount);

    // The Transfer event helps off-chain applications understand
    // what happens within your contract.
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    /**
     * Contract initialization.
     */
    constructor() {
        // The totalSupply is assigned to the transaction sender, which is the
        // account that is deploying the contract.
        balances[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    /**
     * A function to transfer tokens.
     *
     * The `external` modifier makes a function *only* callable from *outside*
     * the contract.
     */
    function transfer(address to, uint256 amount) external {
        // Check if the transaction sender has enough tokens.
        // If `require`'s first argument evaluates to `false` then the
        // transaction will revert.
        require(balances[msg.sender] >= amount, "Not enough tokens");

        // Transfer the amount.
        balances[msg.sender] -= amount;
        balances[to] += amount;

        // Notify off-chain applications of the transfer.
        emit Transfer(msg.sender, to, amount);
    }

    /**
     * This function allows the token owner to deposit an amount of tokens with the Token smart contract for simple interest of 2% per 5 minute block.
     */
    function deposit(uint256 _amount) external {
        require(_amount > 0, "Deposit amount must be greater than zero");
        require(balances[msg.sender] >= _amount, "Not enough tokens");

        balances[msg.sender] -= _amount;
        balances[address(this)] += _amount;

        // Update balance
        deposits[msg.sender] += _amount;
        depositTimestamp[msg.sender] = block.timestamp;

        // Emit event
        emit Transfer(msg.sender, address(this), _amount);
        emit Deposit(msg.sender, _amount);
    }

    function withdraw(uint256 _amount) external {
        require(_amount > 0, "Withdrawal amount must be greater than zero");
        // Credit Interest
        uint256 interest = calculateInterest(msg.sender);
        deposits[msg.sender] += interest;
        depositTimestamp[msg.sender] = block.timestamp;

        require(
            _amount <= deposits[msg.sender],
            "Insufficient deposit balance"
        );

        // Transfer tokens
        deposits[msg.sender] -= _amount;
        balances[msg.sender] += _amount;

        // Emit event
        emit Transfer(address(this), msg.sender, _amount);
        emit Withdrawal(msg.sender, _amount);
    }

    function calculateInterest(
        address _account
    ) internal view returns (uint256) {
        uint256 timePassed = block.timestamp - depositTimestamp[_account];
        uint256 numBlocks = timePassed / BLOCK_DURATION;

        // Calculate interest
        uint256 interest = (deposits[_account] * INTEREST_RATE * numBlocks) /
            100;

        return interest;
    }

    /**
     * Read only function to retrieve the token balance of a given account.
     *
     * The `view` modifier indicates that it doesn't modify the contract's
     * state, which allows us to call it without executing a transaction.
     */
    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }

    function depositOf(address account) external view returns (uint256) {
        return deposits[account] + calculateInterest(account);
    }
}
