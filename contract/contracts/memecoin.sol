// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;
import "./memecoin_stuff/burning.sol";

contract Memecoin { 
  address  owner;
  string message;
  string token_name = "Memecoin";
  string token_symbol = "MEME";
  string decimals = "18";
  uint256 Token_supply = 1000000;
  uint256 Circulating_supply = 0;
  uint256 public Total_Supply = Token_supply;
  uint256 public circulating_supply = Circulating_supply;

  event Transfer(address indexed from, address indexed to, uint256 value);

  modifier onlyOwner() {
    require(msg.sender == owner, "Caller is not the owner");
    _;
  }
  mapping(address => uint256)  public Balances;

  constructor() 
  {
    owner = msg.sender;
    message = "Hello, World!";
    
  }
  function sayhello() public view returns (string memory) {
    return message;
  }
  //minting function
  function mint(uint256 amount) public onlyOwner {
    require(circulating_supply + amount <= Token_supply, "Exceeds total supply");
    // uint newsupply = circulating_supply += amount;
    // circulating_supply = new newsupply;
    circulating_supply += amount;
    fetchValue();

  }
  // burning function
  function burn(uint256 amount) public onlyOwner {
    require(circulating_supply >= amount, "Insufficient supply to burn");
    circulating_supply -= amount;
    fetchValue();
  }
  // Fetch the current value
  function fetchValue() public view returns (uint256) {
    return circulating_supply;
}
// fetch the address balance
function getBalance(address account) public view returns (uint256) {
    return account.balance; 
    }
//transfer function
function transfer(address recipient, uint256 amount) public onlyOwner {
    require(Balances[msg.sender] >= amount, "Insufficient balance");
    Balances[msg.sender] -= amount;
    Balances[recipient] += amount;
    emit Transfer(msg.sender, recipient, amount);

}
    
}
