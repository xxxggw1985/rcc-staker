const { ethers, upgrades } = require("hardhat");

async function main() {
    const rccStakeV1 = await ethers.getContractFactory("RCCStake");
    console.log("Deploying RCCStake...");
    const  rccStake = await upgrades.deployProxy(rccStakeV1,
         ["0x5FbDB2315678afecb367f032d93F642f64180aa3",1,100000000,200], {
        initializer: "initialize",
    });
 
    console.log("RccStake deployed to:", rccStake.target);
}

main();