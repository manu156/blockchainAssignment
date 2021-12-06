pragma solidity 0.8.6;


import "https://github.com/0xcert/ethereum-erc721/blob/master/src/contracts/tokens/nf-token-metadata.sol";
import "https://github.com/0xcert/ethereum-erc721/blob/master/src/contracts/tokens/nf-token-enumerable.sol";
import "https://github.com/0xcert/ethereum-erc721/blob/master/src/contracts/ownership/ownable.sol";

import './ERC2981PerTokenRoyalties.sol';

contract digitalAsset is
  NFTokenEnumerable,
  NFTokenMetadata,
  Ownable,
  ERC2981PerTokenRoyalties
{
    constructor(string memory _name, string memory _symbol) {
    nftName = _name;
    nftSymbol = _symbol;
  }

  // Mint a new NFT coin with _tokenId token ID to _to address with _uri representing RFC3986 URI 
  function mint(address _to, uint256 _tokenId, string calldata _uri, address royaltyRecipient, uint256 royaltyValue)
    external onlyOwner {
    super._mint(_to, _tokenId);
    super._setTokenUri(_tokenId, _uri);
    
    if (royaltyValue > 0) {
        _setTokenRoyalty(_tokenId, royaltyRecipient, royaltyValue);
    } 
  }

  // Remove a NFT
  function burn(uint256 _tokenId) external onlyOwner {
    super._burn(_tokenId);
  }

  function setTokenUriX(uint256 _tokenId, string calldata _uri) external onlyOwner {
    super._setTokenUri(_tokenId, _uri);
  }

  // overide mint a new NFT (internal)function
  function _mint(address _to, uint256 _tokenId) internal override(NFToken, NFTokenEnumerable) virtual {
    NFTokenEnumerable._mint(_to, _tokenId);
  }

  // override internal burn function
  function _burn(uint256 _tokenId) internal override(NFTokenMetadata, NFTokenEnumerable) virtual {
    NFTokenEnumerable._burn(_tokenId);
    if (bytes(idToUri[_tokenId]).length != 0) {
      delete idToUri[_tokenId];
    }
  }

  // override remove NFT token function 
  function _removeNFToken(address _from, uint256 _tokenId) internal override(NFToken, NFTokenEnumerable) {
    NFTokenEnumerable._removeNFToken(_from, _tokenId);
  }

  // overide assign a new NFT to _to address
  function _addNFToken(address _to, uint256 _tokenId)
    internal override(NFToken, NFTokenEnumerable) {
    NFTokenEnumerable._addNFToken(_to, _tokenId);
  }

  // returns Number of _owner NFTs
  function _getOwnerNFTCount(address _owner) internal override(NFToken, NFTokenEnumerable)
    view returns (uint256) {
    return NFTokenEnumerable._getOwnerNFTCount(_owner);
  }
}
