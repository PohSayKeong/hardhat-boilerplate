async function main() {
    const [deployer, acc2] = await ethers.getSigners();
    const deployerAddress = await deployer.getAddress();
    const acc2Address = await acc2.getAddress();
    console.log("Deploying the contracts with the account:", deployerAddress);

    console.log("Account balance:", (await deployer.getBalance()).toString());

    const Token = await ethers.getContractFactory("Token");
    const token = await Token.deploy();
    await token.deployed();

    console.log("Token address:", token.address);
    const deployerTokenBalance = await token.balanceOf(deployerAddress);
    console.log("Token owner balance:", deployerTokenBalance.toString());

    // transfer 1000 tokens to acc2
    const transferTx = await token.transfer(await acc2.getAddress(), 1000);
    await transferTx.wait();
    const acc2TokenBalance = await token.balanceOf(acc2Address);
    console.log("acc2 balance:", acc2TokenBalance.toString());

    // deposit 500 tokens from acc2
    const token2 = token.connect(acc2);
    const depositTx = await token2.deposit(500);
    await depositTx.wait();
    const depositBalance = await token.depositOf(acc2Address);
    console.log("acc2 deposit in contract:", depositBalance.toString());
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
