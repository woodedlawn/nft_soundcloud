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
    
    function getName() public view returns (Sound[name] memory) {
        uint tokenCount = totalSupply;

        if (tokenCount == 0) {
            print("There is no artist by that name currently, invite to our NFT platform.");
        } else {
            Sound[name] memory namesounds = new Sound[name](tokenCount);
            for (uint x=0; x<tokenCount; x++) {
                Sound storage sound = soundCollection[x];
                namesounds[x] =namesound;
            }
            return namesounds;
        }

    }

    function getGenre() public view returns (Sound[genre] memory) {
        uint tokenCount = totalSupply;

        if (tokenCount == 0) {
            print("This genre has not been uploaded yet. Add this genre to our catalog!");
        } else {
            Sound[genre] memory genresounds = new Sound[genre](tokenCount);
            for (uint y=0; y<tokenCount; y++) {
                Sound storage sound = soundCollection[y];
                genresounds[y] =genresound;
            }
            return genresounds;
        }

    }

        function getInstrument() public view returns (Sound[instrument] memory) {
        uint tokenCount = totalSupply;

        if (tokenCount == 0) {
            print("There are no samples using this instrument currently, be the first and upload one!");
        } else {
            Sound[instrument] memory instrumentsounds = new Sound[instrument](tokenCount);
            for (uint f=0; f<tokenCount; f++) {
                Sound storage sound = soundCollection[f];
                instrumentsounds[f] =instrumentsound;
            }
            return instrumentsounds;
        }

    }

        function getUri() public view returns (Sound[tokenURI] memory) {
        uint tokenCount = totalSupply;

        if (tokenCount == 0) {
            print("This URI is invalid please check your input again.");
        } else {
            Sound[tokenURI] memory tokenURIsounds = new Sound[tokenURI](tokenCount);
            for (uint q=0; q<tokenCount; q++) {
                Sound storage sound = soundCollection[q];
                tokenURIsounds[q] =tokenURIsound;
            }
            return tokenURIsounds;
        }

    }


    
}
  

