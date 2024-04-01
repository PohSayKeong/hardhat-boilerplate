async function main() {
    const [, acc2] = await ethers.getSigners();
    const acc2Address = await acc2.getAddress();
    const Token = await ethers.getContractFactory("Token");
    const token = Token.attach(
        "0x9b3fDf524E4e2704541c2069571DaB266D9Da6E0"
    ).connect(acc2); // replace this with actual contract address

    // only applicable for localhost network
    // const { time } = require("@nomicfoundation/hardhat-network-helpers");
    // await time.increase(300); // after an hour

    const depositBalance = await token.depositOf(acc2Address);
    console.log("acc2 deposit in contract:", depositBalance.toString());

    // withdraw 500 tokens
    const withdrawTx = await token.withdraw(500);
    await withdrawTx.wait();
    // acc2 should have 1000 tokens
    const tokenBalance = await token.balanceOf(acc2Address);
    console.log("acc2 balance after withdraw:", tokenBalance.toString());
    // acc2 should have 10 tokens in contract
    const depositBalanceAfterWithdraw = await token.depositOf(acc2Address);
    console.log(
        "acc2 deposit in contract after withdraw:",
        depositBalanceAfterWithdraw.toString()
    );
}

main();
