const {
    loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers,upgrades} = require("hardhat");
const helpers  = require("@nomicfoundation/hardhat-network-helpers");

describe("ADD Pool", function () {

    describe("Deployment", function () {
        async function deployRccStateFixture() {
            const rccStakeV1 = await ethers.getContractFactory("RCCStake");
            console.log("Deploying RCCStake...");
            const  rccStake = await upgrades.deployProxy(rccStakeV1,
                 ["0x5FbDB2315678afecb367f032d93F642f64180aa3",1,100000000,200], {
                initializer: "initialize",
            });
           return {rccStake}
        }
        it("Should deploy  success", async function () {
            const {rccStake} = await loadFixture(deployRccStateFixture);
            expect(await rccStake.RCC()).to.equal("0x5FbDB2315678afecb367f032d93F642f64180aa3");
            expect(await rccStake.RCCPerBlock()).to.equal(200);
            expect(await rccStake.startBlock()).to.equal(1);
            expect(await rccStake.endBlock()).to.equal(100000000);

           
        })

        it("Should deploy  success", async function () {
           
            // startBlock of contract should be the bigger bwteen block.number and _startBlock
            await helpers.mineUpTo(100);
            const {rccStake} = await loadFixture(deployRccStateFixture);
             
        })
    }
        




    
    );
    
})