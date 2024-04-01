require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");

// The next line is part of the sample project, you don't need it in your
// project. It imports a Hardhat task definition, that can be used for
// testing the frontend.
require("./tasks/faucet");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    solidity: "0.8.17",
    networks: {
        sepolia: {
            url: "https://sepolia.drpc.org",
            accounts: {
                mnemonic: process.env.MNEMONIC,
            },
        },
        hardhat: {
            accounts: {
                mnemonic: process.env.MNEMONIC,
            },
        },
    },
};
