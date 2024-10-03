const {time,loadFixture} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
import hre, { ethers } from "hardhat";

describe("NftMarketPlace", function(){
    async function deployNftMarketPlace(){
        const[owner, buyer, seller, otherAddr] = await ethers.getSigners();
        const PRICE = ethers.parseEther("0.1")
        const TOKEN_ID = 0;
       
        //deploy nft
        const nftContract = await hre.ethers.getContractFactory("MyNFT");
        const nftAddress = await nftContract.deploy();

        //deploy nft market place
        const nftMarketPlaceContract = await hre.ethers.getContractFactory("NftMarketPlace");
        const nftMarketPlace = await nftMarketPlaceContract.deploy();

        await nftAddress.connect(seller).mintNFT();
        await nftAddress.connect(seller).approve(nftMarketPlace, TOKEN_ID);

        const tokenCounter = await nftAddress.getTokenCounter();
        expect(tokenCounter).to.equal(1); 
        expect(await nftAddress.ownerOf(0)).to.equal(seller.address); // Seller owns the NFT

        return { nftMarketPlace, nftAddress, buyer, seller,owner,TOKEN_ID, PRICE}
    }

    describe("deployment", function(){
        it("should deploy the marketplace and nft", async()=>{
            const{owner, nftMarketPlace} = await loadFixture(deployNftMarketPlace);
            expect(await nftMarketPlace._owner()).to.equal(owner.address);
        });
    });

    describe("listNft", function(){
        it("list nfts", async()=>{
            
            
            const{owner, nftMarketPlace, nftAddress, PRICE, seller,TOKEN_ID} = await loadFixture(deployNftMarketPlace);
            await nftAddress.connect(seller).mintNFT();
            await nftAddress.connect(seller).approve(nftMarketPlace, TOKEN_ID); 

            expect(await nftMarketPlace.connect(seller).listNft(nftAddress, TOKEN_ID, PRICE)).to.emit("nftListed");

            // expect(listing.price).to.equal(ethers.utils.parseEther("1"));
            // expect(listing.seller).to.equal(seller.address);
        });

    });


});