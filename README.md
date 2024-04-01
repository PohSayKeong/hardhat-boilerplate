## Setup
Have a MNEMONIC key in .env at the root directory. This is a 12 word seed phrase

`npm install` to install dependencies


## Task 1
Code can be found in `/contracts/Token.sol`

`depositTimestamp` stores the timestamp of the last deposit made by the user and this is where the interest calculation is based on

the `transfer` event is also emitted when a transfer is made as this should happen for all token transfers

## Task 2
hardhat config can be found in `/hardhat.config.js`

Relevant scripts are found in `/scripts`

Deploy contract: `npm run deploy-sepolia`

After contract deployment, take note of the contract address and update the contract address in `/scripts/withdraw-sepolia.js` on line 6

Withdraw: `npm run withdraw-sepolia`

## Task 3
Code can be found in `/test/Token.js`

Test code for interest related functions are under Interest