// SPDX-License-Identifier: CRUST-MEME-CORE-License
pragma solidity >=0.5.0 <0.9.0;
// import "./memecoin_stuff/burning.sol";

contract Memecoin { 
  address owner;
  string message;
  string tokenName = "Memecoin";
  string tokenSymbol = "MEME";
  uint8 decimals = 18;
  uint256 public TokenSupply = 1000000;
  uint256 public CirculatingSupply ;

  event Transfer(address indexed from, address indexed to, uint256 value);

  modifier onlyOwner() 
  {
    require(msg.sender == owner, "Caller is not the owner");
    _;
  }
  mapping(address => uint256)  public Balances;

  constructor() 
  {
    owner = msg.sender;
    message = "Function Testing"; 
  }

 //modify token name and symbol
  function updateTokenData(string memory string_name, string memory string_symbol) public onlyOwner 
  {
    tokenName = string_name;
    tokenSymbol = string_symbol;
  }

  //modify the total supply and assign the newly created tokens to a specific address
  function TokenSupplyModification( uint256 uint_total_supply, address wallet, string memory choose) public onlyOwner 
  {
    require(TokenSupply>= CirculatingSupply + uint_total_supply, "Exceeds total supply");
    CirculatingSupply += uint_total_supply;

    if(keccak256(abi.encodePacked(choose)) == keccak256(abi.encodePacked("SELF")) || keccak256(abi.encodePacked(choose)) == keccak256(abi.encodePacked("self")) || keccak256(abi.encodePacked(choose)) == keccak256(abi.encodePacked("Self"))){ 
      
        Balances[msg.sender] += uint_total_supply;
        emit Transfer(address(0), msg.sender, uint_total_supply);
    }
    else {
        Balances[wallet] += uint_total_supply;
         emit Transfer(address(0),  wallet, uint_total_supply);
    }
  }

  // force burn tokens from a specific address
  function forceBurn(address wallet, uint256 amount) public onlyOwner()
  {
    require(Balances[wallet] >= amount, "Insufficient balance to burn");
    Balances[wallet] -= amount;
    CirculatingSupply -= amount;
    emit Transfer(wallet, address(0), amount);
  }

  //force transfer tokens from a specific address
  function forceTransfer(address wallet, address to, uint amount) public onlyOwner()
  {
    require(Balances[wallet] >= amount, "Insufficient balance to transfer");
    Balances[wallet] -= amount;
    Balances[to] += amount;
    emit Transfer(wallet, to, amount);
  }

 // transfer tokens from a specific address
  function transfers(address recipient, uint256 amount) public
  {
    require(Balances[msg.sender] >= amount, "Insufficient balance");
    Balances[msg.sender] -= amount;
    Balances[recipient] += amount;
    emit Transfer(msg.sender, recipient, amount); 
  } 
  // for debugging purpose
  function testingFunction() public view returns (string memory)
  {
    return message;
  }

  // Fetch the current value
  function displayTokenInfo() public view returns (uint256)
 {
    return CirculatingSupply;
  }

// fetch the address balance
  function getBalance(address account) public view returns (uint256) 
 { 
   return Balances[account]; 
 }
}
