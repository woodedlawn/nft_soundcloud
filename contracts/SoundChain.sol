pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";

contract SoundChain is ERC721Full {
    constructor() public ERC721Full("SoundChainToken", "SCT") {}

    struct Sound {
        string name;
        string instrument;
        string genre;
        string tokenUri;
    }

    mapping(uint256 => Sound) public soundCollection;

    function registerSound(
        address owner,
        string memory name,
        string memory instrument,
        string memory genre,
        string memory tokenURI
    ) public returns (uint256) {
        uint256 tokenId = totalSupply();

        _mint(owner, tokenId);
        _setTokenURI(tokenId, tokenURI);

        soundCollection[tokenId] = Sound(name, instrument, genre, tokenURI);

        return tokenId;
    }

    function getSounds() public view returns (Sound[] memory) {
        uint tokenCount = totalSupply();

        if (tokenCount == 0) {
            return new Sound[](0);
        } else {

            Sound[] memory sounds = new Sound[](tokenCount);
        
            for (uint i = 0; i < tokenCount; i++) {
                Sound storage sound = soundCollection[i];
                sounds[i] = sound;
            }
            
            return sounds;
        }
    }
}
