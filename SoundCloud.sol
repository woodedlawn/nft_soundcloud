pragma solidity ^0.5.0;

//import "https://github.com/ProjectOpenSea/opensea-creatures/blob/master/contracts/ERC721Tradable.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";
// import '@openzeppelin/contracts-ethereum-package/contracts/token/ERC721/ERC721Full.sol';

import "https://github.com/athiwatp/openzeppelin-solidity/blob/master/contracts/token/ERC721/ERC721Full.sol";
import"https://github.com/athiwatp/openzeppelin-solidity/blob/master/contracts/token/ERC721/ERC721MetadataMintable.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";


contract SoundCloud is ERC721Full {
    // , _proxyRegistryAddress

    string public token = "SCT";
    address payable owner = msg.sender;
    
    constructor(
        address _proxyRegistryAddress
        ) public ERC721Full("Creature", "OSC") {  }
    

    
    function baseTokenURI() public pure returns (string memory) {
        return "https://opensea-creatures-api.herokuapp.com/api/creature/";
  }
    
    // function request_nft(address recipient) public view {
    //     require(recipient==msg.sender, "You are not authorized to use this account");
    //     // _mint(msg.sender, 1);
    // }
    
    // function tokenOwner(address payable tokenOwner, address payable requestor) public {
    //     return tokenOwner(requestor);
    // }
    
    mapping(address => string) tokenArtist;

     function awardToken(address artist, string memory tokenURI)
    public
    returns (uint256)
    {
        uint256 newTokenId;
        _mint(artist, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        
        return newTokenId;
    }
    
    
    
}
//"SoundCloud Token", "SCT"
// contract SC_Token is ERC721MetadataMintable {
//     constructor() public ERC721MetadataMintable() {}
    
//     function awardToken(address artist, string memory tokenURI)
//     public
//     returns (uint256)
//     {
//         uint256 newTokenId;
//         _mint(artist, newTokenId);
//         _setTokenURI(newTokenId, tokenURI);
        
//         return newTokenId;
//     }
// }