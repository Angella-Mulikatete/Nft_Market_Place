// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

error AlreadyListed(address nftAddress, uint256 tokenId);
error NotOwner();
error PriceMustBeGreaterThanZero();
error NotApprovedForMarketPlace();


contract NftMarketPlace  is ReentrancyGuard,ERC721, ERC721Burnable {

    struct List{
        uint256 price;
        address seller;
    }

    constructor() ERC721("MyToken", "MTK")  {}

    event nftListed(address indexed seller, address indexed nftAddress,uint256 indexed tokenId,uint256 price);
    mapping(address => mapping(uint256 => List)) private lists; //address => tokenId => list
    mapping(address => uint256) private seller; //address of the seller => nft price


    modifier notListed(address nftAddress, uint256 tokenId, address owner){
        List memory _list = lists[nftAddress][tokenId];
        if(_list.price >0){
            revert AlreadyListed(nftAddress, tokenId);
        }
        _;
    }

    modifier onlyOwner(address nftAddress, uint256 tokenId, address spender){
        IERC721 nft = IERC721(nftAddress);
        address owner = nft.ownerOf(tokenId);
        if(spender != owner){
            revert NotOwner();
        }
        _;
    }


    function listItem(address nftAddress, uint256 tokenId, uint256 price) 
        external notListed(nftAddress, tokenId, msg.sender) onlyOwner(nftAddress, tokenId, msg.sender)
    {
        if(price <= 0){
            revert PriceMustBeGreaterThanZero();
        }

        IERC721 nft = IERC721(nftAddress);
        if(nft.getApproved(tokenId) != address(this)){
            revert NotApprovedForMarketPlace();
        }

        lists[nftAddress][tokenId] = List(price, msg.sender);
        emit nftListed(msg.sender, nftAddress, tokenId, price);
    }

    function updateList(address nftAddress, uint256 tokenId, uint256 price) external {}

    function cancelList(address nftAddress, uint256 tokenId, uint256 price) external {}

    function BuyItem() external {}

    function withdraw() external {}

    function getListing(address nftAddress, uint256 tokenId, uint256 price) external{}
}

//MyNFTModule#MyNFT - 0x8d9bBf937d90B8dd18f8Bf6901c767a052c9ab40