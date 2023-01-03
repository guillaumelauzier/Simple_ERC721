pragma solidity ^0.7.1;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/SafeERC721.sol";

// This contract is a simple example of an ERC721 non-fungible token

// The name of the NFT
string public name;

// The symbol of the NFT
string public symbol;

// The base URI of the NFT
string public baseURI;

// The total supply of the NFT
uint256 public totalSupply;

// Mapping of token IDs to token metadata
mapping (uint256 => TokenMetadata) public tokens;

// A struct that holds the metadata for a token
struct TokenMetadata {
  string name;
  string description;
  string imageURI;
}

// ERC721 implementation
SafeERC721 public safeERC721;

constructor(string memory _name, string memory _symbol, string memory _baseURI) public {
  name = _name;
  symbol = _symbol;
  baseURI = _baseURI;

  // Create the ERC721 implementation
  safeERC721 = new SafeERC721(_name, _symbol);
}

// Mint a new token
function mint(uint256 _tokenId, string memory _name, string memory _description, string memory _imageURI) public {
  // Only the contract owner can mint new tokens
  require(msg.sender == owner, "Only the contract owner can mint new tokens");

  // Token ID must be unique
  require(tokens[_tokenId].name == "", "Token ID must be unique");

  // Update the token metadata
  tokens[_tokenId] = TokenMetadata(_name, _description, _imageURI);

  // Add the token to the ERC721 implementation
  safeERC721.mint(msg.sender, _tokenId);

  // Increase the total supply
  totalSupply++;
}

// Get the metadata of a token
function getTokenMetadata(uint256 _tokenId) public view returns (string memory, string memory, string memory) {
  TokenMetadata memory metadata = tokens[_tokenId];
  return (metadata.name, metadata.description, metadata.imageURI);
}

// Get the owner of a token
function ownerOf(uint256 _tokenId) public view override returns (address) {
  return safeERC721.ownerOf(_tokenId);
}

// Transfer a token to another address
function transfer(address _to, uint256 _tokenId) public {
  safeERC721.transfer(_to, _tokenId);
}

// Approve another address to transfer a token
function approve(address _to, uint256 _tokenId) public {
  safeERC721.approve(_to, _tokenId);
}
