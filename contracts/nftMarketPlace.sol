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
error NotListedYet(address nftAddress, uint256 tokenId);
error InsufficientFunds(address nftAddress, uint256 tokenId, uint256 price);
error newPriceMustBeAboveZero();


contract NftMarketPlace  is ReentrancyGuard,ERC721, ERC721Burnable {

    struct List{
        uint256 price;
        address seller;
    }
    address public _owner;
    constructor() ERC721("AngieNFt", "ATK")  {
        _owner = msg.sender;
    }

    event nftListed(address indexed seller, address indexed nftAddress,uint256 indexed tokenId,uint256 price);
    event nftCanceled(address indexed seller,address indexed nftAddress,uint256 indexed tokenId);
    event nftBought(address indexed buyer,address indexed nftAddress,uint256 indexed tokenId,uint256 price);

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

    modifier isListed(address nftAddress, uint256 tokenId){
        List memory _lists = lists[nftAddress][tokenId];
        if(_lists.price <=0){
            revert NotListedYet(nftAddress, tokenId);
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

    function updateList(address nftAddress, uint256 tokenId, uint256 newPrice) 
        external isListed(nftAddress, tokenId) onlyOwner(nftAddress, tokenId, msg.sender) nonReentrant
    {
        if(newPrice == 0){
            revert newPriceMustBeAboveZero();
        }

        lists[nftAddress][tokenId].price = newPrice;
        emit nftListed(msg.sender, nftAddress, tokenId, newPrice);
    }

    function cancelList(address nftAddress, uint256 tokenId) 
        external isListed(nftAddress, tokenId) onlyOwner(nftAddress, tokenId, msg.sender)
    {
        delete(lists[nftAddress][tokenId]);
        emit nftCanceled(msg.sender, nftAddress, tokenId);
    }

    function buyNft(address _nftAddress, uint256 _tokenId) 
        external payable isListed(_nftAddress, _tokenId) nonReentrant
    {
        List memory listedNft = lists[_nftAddress][_tokenId];

        if(msg.value < listedNft.price){
            revert InsufficientFunds(_nftAddress, _tokenId, listedNft.price);
        }

        seller[listedNft.seller] += msg.value;
        delete(lists[_nftAddress][_tokenId]); //deleted after the exchange of nft.

        IERC721(_nftAddress).safeTransferFrom(listedNft.seller, msg.sender, _tokenId);
        emit nftBought(msg.sender, _nftAddress, _tokenId, listedNft.price);

    }

    function withdraw() external {}

    function getListing(address nftAddress, uint256 tokenId, uint256 price) external{}
}

