const {time,loadFixture} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
import hre, { ethers } from "hardhat";

describe("NftMarketPlace", function(){
    async function deployNftMarketPlace(){
        const[owner, buyer, seller, otherAddr] = await ethers.getSigners();
        const PRICE = ethers.parseEther("0.1")
        const TOKEN_ID = 0
       
        //deploy nft
        const nftContract = await hre.ethers.getContractFactory("MyNFT");
        const nft = await nftContract.deploy();

        //deploy nft market place
        const nftMarketPlaceContract = await hre.ethers.getContractFactory("NftMarketPlace");
        const nftMarketPlace = await nftMarketPlaceContract.deploy();

        await nft.connect(seller).mintNFT();
        await nft.connect(seller).approve(nftMarketPlace, TOKEN_ID);

        return { nftMarketPlace, nft, buyer, seller,owner}
    }

    describe("deployment", function(){
        it("should deploy the marketplace and nft", async()=>{
            const{owner, nftMarketPlace} = await loadFixture(deployNftMarketPlace);
            expect(await nftMarketPlace._owner()).to.equal(owner.address);
        });
    });


});