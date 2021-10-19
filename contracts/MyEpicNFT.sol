// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.0;

// We first import de OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

/**
 * We inherit the contract we imported. This means we'll have access
 * to the inherited contract's methods.
 */
contract MyEpicNFT is ERC721URIStorage {
    // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // We need to pass the name of our NFTs token and it's symbol.
    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("this is my NFT contract. Woah!");
    }

    // A function out user will hit to get ther NFT
    function makeAnEpicNFT () public {
        // Get the current tokenId, this starts at 0.
        uint256 newItemId = _tokenIds.current();

        // Actually mint the NFT to the sender using msg.sender.
        _safeMint(msg.sender, newItemId);

        // Set the NFT data.
        _setTokenURI(newItemId, "https://jsonkeeper.com/b/ONTQ");
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();
    }
    
}
