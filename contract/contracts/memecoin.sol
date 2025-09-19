// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Memecoin { 
  string message;
  uint256 value;
  string token_name = "Memecoin";
  string token_symbol = "MEME";
  uint256 Token_supply = 1000000;
  uint256 circulating_supply = 0;
  uint256 public totalSupply = Token_supply;
  constructor() 
  {
    message = "Hello, World!";
    
  }
  function sayhello() public view returns (string memory) {
    return message;
  }
  //minting function
  function mint(uint256 amount) public {
    require(circulating_supply + amount <= Token_supply, "Exceeds total supply");
    circulating_supply += amount;
  }
  // Fetch the current value
  function fetchValue() public view returns (uint256) {
    return value;
}
}
