// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract memecoin { 
  string message;
  constructor() 
  {
    message = "Hello, World!";
  }
  function sayhello() public view returns (string memory) {
    return message;
  }
}
