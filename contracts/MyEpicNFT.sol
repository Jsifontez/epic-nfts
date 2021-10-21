// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.0;

// We first import de OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";


/**
 * We inherit the contract we imported. This means we'll have access
 * to the inherited contract's methods.
 */
contract MyEpicNFT is ERC721URIStorage {
    // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
    // So, we make a baseSvg variable here that all our NFTs can use.
    // I split the svg to assign random colors
    string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";


    // three arrays of words for pick random names
    string[] firstWords = ["Beautiful", "Big", "Small", "Unusual", "Red", "Nine", "Plastic", "Thin", "Red", "Liquid"];
    string[] secondWords = ["Sovereign", "Lord", "God", "Emperor", "Star", "Miss", "King", "Assasin", "Stronger", "Fatness"];
    string[] thirdWords = ["LongChen", "Itadori", "Fitzgeralds", "Rikimaru", "Heir", "Debtor", "Aaron", "Altuve", "MenQi"];

    // Creat fancy colors to pick
    string[] colors = ["rebeccapurple", "crimson", "#002147", "#567d46", "#e75480", "#B30E16", "black", "#F57513", "#B87333", "#40E0D0"];

    // We use a event to get the token id
    event NewEpicNFTMinted(address sender, uint256 tokenId);

    // Create a function to randomly pick a word from each array
    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        // I seed the random generator. More on this in the lesson.
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        // Squash the # between 0 and the length of the array to avoid going out of bounds.
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return thirdWords[rand];
    }

    function pickRandomColor(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("COLOR", Strings.toString(tokenId))));
        rand = rand % colors.length;
        return colors[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    // We need to pass the name of our NFTs token and it's symbol.
    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("this is my NFT contract. Woah!");
    }

    // a function to call in web client to know the minted nft
    function nftMintedSoFat () public view returns (uint256) {
        return _tokenIds.current();
    }

    // A function out user will hit to get ther NFT
    function makeAnEpicNFT () public {
        // Get the current tokenId, this starts at 0.
        uint256 newItemId = _tokenIds.current();

        require(newItemId < 51, "The minted operation has reached the limit");

        // We go and randomly grab one word from each of the three arrays.
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combineWord = string(abi.encodePacked(first, second, third));

        // Add random color
        string memory randomColor = pickRandomColor(newItemId);
        // Lets concatenate it all together, and then close the <text> and <svg> tags.
        string memory finalSvg = string(abi.encodePacked(svgPartOne, randomColor, svgPartTwo, combineWord, "</text></svg>"));

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combineWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        // Actually mint the NFT to the sender using msg.sender.
        _safeMint(msg.sender, newItemId);

        // Set the NFT data.
        // for encode data you can use the web: https://www.utilities-online.info/base64
        _setTokenURI(newItemId, finalTokenUri);
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();

        // We emit the event defined in line 34
        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
    
}
