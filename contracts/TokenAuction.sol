pragma solidity ^0.4.24;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import "zeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import '/home/andreizoltan/auction/contracts/GradientToken.sol';

contract TokenAuction {
  ERC721 public nonFungibleContract;
  //nonFungibleContract is ERC721, Ownable;

  struct Auction {
    address seller;
    uint128 price;
  }

  mapping (uint256 => Auction) public tokenIdToAuction;

  constructor ( address _nftAddress ) public {
    nonFungibleContract = ERC721(_nftAddress);
  }

  function createAuction( uint256 _tokenId, uint128 _price ) public {
    nonFungibleContract.transferFrom(msg.sender, this, _tokenId);
    //transferOwnership(_tokenId);
    Auction memory _auction = Auction({
       seller: msg.sender,
       price: uint128(_price)
    });
    tokenIdToAuction[_tokenId] = _auction;
  }

  function bid( uint256 _tokenId ) public payable {
  Auction memory auction = tokenIdToAuction[_tokenId];
  require(auction.seller != address(0));
  require(msg.value >= auction.price);

  address seller = auction.seller;
  uint128 price = auction.price;

  delete tokenIdToAuction[_tokenId];

  seller.send(price);
  nonFungibleContract.transferFrom(msg.sender, this, _tokenId);
}

  function cancel( uint256 _tokenId ) public {
  Auction memory auction = tokenIdToAuction[_tokenId];
  require(auction.seller == msg.sender);

  delete tokenIdToAuction[_tokenId];

  nonFungibleContract.transferFrom(msg.sender, this,  _tokenId);
  //nonFungibleContract.transfer(msg.sender, _tokenId);
}
}
