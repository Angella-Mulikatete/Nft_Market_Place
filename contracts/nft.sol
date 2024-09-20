// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {

    string public constant TOKEN_URI = "ipfs://QmeGvXvqoXSrrXQM8gmpCde4sSp25Fmx1CK5TEY8fhdJzd";
    uint256 tokenCounter;

    event nftMinted(uint256 indexed tokenId);

    constructor() ERC721("AngieNFt", "ATK") Ownable(msg.sender) {
        tokenCounter = 0;
    }

    function mintNFT() public {
        _safeMint(msg.sender,tokenCounter);
        emit nftMinted(tokenCounter);
        tokenCounter ++;

    }

    // The following functions are overrides required by Solidity.

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return TOKEN_URI;
    }

     function getTokenCounter() public view returns (uint256) {
        return tokenCounter;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}

//MyNFTModule#MyNFT - 0x8d9bBf937d90B8dd18f8Bf6901c767a052c9ab40