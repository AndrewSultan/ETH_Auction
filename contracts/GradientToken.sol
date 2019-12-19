pragma solidity ^0.4.17;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract GradientToken is ERC721Token, Ownable {
  constructor(string memory name, string memory symbol)
  ERC721Token(name,symbol)
  public {
  }
  struct Gradient {
    string outer;
    string inner;
  }

  Gradient[] public gradients;
  mapping (address => uint256[]) private owner_to_tokens_id;

  function getGradient( uint _gradientId ) public view returns(string outer, string inner){
    Gradient memory _grad = gradients[_gradientId];

    outer = _grad.outer;
    inner = _grad.inner;
  }

  function mint(string _outer, string _inner) public payable onlyOwner{
    Gradient memory _gradient = Gradient({ outer: _outer, inner: _inner });
    uint _gradientId = gradients.push(_gradient) - 1;

    _mint(msg.sender, _gradientId);
    owner_to_tokens_id[msg.sender].push(_gradientId);
  }

  function tokensOf(address owner) public view returns(uint256[]){
    return owner_to_tokens_id[owner];
  }
}
