// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract NftMarketPlace  is ReentrancyGuard  {


    function listItem(address nftAddress, uint256 tokenId, uint256 price) external {}

    function updateList(address nftAddress, uint256 tokenId, uint256 price) external {}

    function cancelList(address nftAddress, uint256 tokenId, uint256 price) external {}

    function BuyItem() external {}

    function withdraw() external {}

    function getListing(address nftAddress, uint256 tokenId, uint256 price) external{}
}

//MyNFTModule#MyNFT - 0x8d9bBf937d90B8dd18f8Bf6901c767a052c9ab40