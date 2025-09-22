// SPDX-License-Identifier: CRUST-MEME-CORE-License
pragma solidity >=0.5.0 <0.9.0;
// import "./memecoin_stuff/burning.sol";

contract Memecoin { 
  address owner;
  string message;
  string _name = "Memecoin";
  string _symbol = "MEME";
  uint8 _decimal = 18;
  uint256 public cap = 1000000;
  uint256 public mintedSupply ;
  uint256 public saleCounter;
  uint256 public saleEarning;
  uint256 public preMintPrice;
  uint256 public preMintSupply;
  uint256 public preMintSupplyRemaining;
  uint256 public minBuy;
  uint256 public maxBuyLimit;

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner, string reason);
  event OwnerMinted(address indexed owner , uint256 amount);
  event mintDetailsSet(uint256 preMintPrice, uint256 minBuy, uint256 maxBuyLimit, uint256 preMintSupply);
  modifier onlyOwner() 
  {
    require(msg.sender == owner, "Caller is not the owner");
    _;
  }
  mapping(address => uint256)  public Balances; 
  mapping(address => mapping(address => uint256)) public allowance;

  constructor() 
  {
    owner = msg.sender;
    message = "Function Testing"; 
  }

 //modify token name and symbol
  function updateTokenData(string memory string_name, string memory string_symbol) public onlyOwner 
  {
    _name = string_name;
    _symbol = string_symbol;
  }

  //modify the total supply and assign the newly created tokens to a specific address
  function capModification( uint256 circulationIncrease, address wallet, string memory choose) public onlyOwner 
  {
    require(cap>= mintedSupply + circulationIncrease, "Exceeds total supply");
    mintedSupply += circulationIncrease;

    if(keccak256(abi.encodePacked(choose)) == keccak256(abi.encodePacked("SELF")) || keccak256(abi.encodePacked(choose)) == keccak256(abi.encodePacked("self")) || keccak256(abi.encodePacked(choose)) == keccak256(abi.encodePacked("Self"))){ 
      
        Balances[msg.sender] += circulationIncrease;
        emit Transfer(address(0), msg.sender, circulationIncrease);
    }
    else {
        Balances[wallet] += circulationIncrease;
         emit Transfer(address(0),  wallet, circulationIncrease);
    }
  }
  
  // mint to any address
  function mint(uint256 amount, address to)  public onlyOwner()
  {
   require(mintedSupply + amount <= cap, "Exceeds market cap");
   Balances[to] += amount;
   mintedSupply += amount;
   emit Transfer(address(0), to, amount);
  }
  
  //mint owner only
  function mintOwner(uint256 amount) public onlyOwner()
  {
    require(mintedSupply + amount <= cap, "Exceeds market cap");
   Balances[msg.sender] += amount;
   mintedSupply += amount;
   emit Transfer(address(0), msg.sender, amount);
   emit OwnerMinted(msg.sender, amount);
  }

  //approve tokens for spending
  function approve(address spender, uint256 amount) public returns (bool)
  {
    allowance[msg.sender][spender] = amount;
    emit Approval(msg.sender, spender, amount);
    return true;
  }

// transfer from
  function transferFrom(address sender , address recipient, uint256 amount) public returns (bool)
  {
  require(Balances[sender] >= amount , "insufficient balance");
  require(allowance[sender][msg.sender] >= amount, "Insufficient allowance");
  Balances[sender] -= amount;
  Balances[recipient] += amount;
  allowance[sender][msg.sender] -= amount;
  emit Transfer(sender, recipient, amount);
  return true;  
  }

  // force burn tokens from a specific address
  function forceBurn(address wallet, uint256 amount) public onlyOwner()
  {
    require(Balances[wallet] >= amount, "Insufficient balance to burn");
    Balances[wallet] -= amount;
    mintedSupply -= amount;
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
  function transfer(address recipient, uint256 amount) public returns (bool)
  {
    require(Balances[msg.sender] >= amount, "Insufficient balance");
    Balances[msg.sender] -= amount;
    Balances[recipient] += amount;
    emit Transfer(msg.sender, recipient, amount); 
    return true;
  } 

  // for debugging purpose
  function testingFunction() public view returns (string memory)
  {
    return message;
  }

// basic function requirements for erc 20 standard

  // Fetch the total supply
  function totalSupply() public view returns (uint256)
 {
    return mintedSupply;
  }

// fetch the address balance
  function balanceOf(address account) public view returns (uint256) 
 { 
   return Balances[account]; 
 }

  // Fetch the token name
  function name() public view returns (string memory)
 {
    return _name;
 }

   // Fetch the token supply
  function maxSupply() public view returns (uint256)
 {
    return cap;
 }

  // Fetch the token symbol
  function symbol() public view returns (string memory)
 {
    return _symbol;
 }

  // Fetch the token decimals
  function decimals() public view returns (uint8)
 {
    return _decimal;
 }

 // other function increase allowance and decrease allowance 
  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) 
  {
    allowance[msg.sender][spender] += addedValue;
    emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
    return true;
  }

  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) 
  {
    uint256 currentAllowance = allowance[msg.sender][spender];
    require(currentAllowance >= subtractedValue, "Decreased allowance below zero");
    allowance[msg.sender][spender] = currentAllowance - subtractedValue;
    emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
    return true;
  }
 function allowanceOf(address owner_, address spender_) public view returns (uint256)
 {
   return allowance[owner_][spender_];
 }

// crucial byt required function
// ownersip transfer
function transferOwnership(address newOwner , string  memory _reason) public onlyOwner 
{
  require(newOwner != address(0), "New owner is the zero address");
  owner = newOwner;
  emit OwnershipTransferred(msg.sender, newOwner, _reason);
}

// token buy function for users
function tokenBuy( address buyer, uint256 amount, uint256 cost ) public payable
{
  cost = amount * preMintPrice;
  require(buyer != address(0), "Buyer is the zero address");
  require(amount >= minBuy, "Buy amount is less than minimum buy");
  require(amount<= maxBuyLimit , "Buy amount exceeds maximum buy limit");
  require(msg.value >= cost, "Insufficient payment");
  require(preMintSupplyRemaining >= amount, "Pre-mint supply exhausted");
  require(Balances[buyer] + amount <= maxBuyLimit, "Purchase exceeds maximum buy limit");
  require(preMintSupply >= preMintSupplyRemaining + amount, "exceeds premint supply");
  Balances[buyer] += amount;
  Balances[owner] -= amount;
  preMintSupplyRemaining -= amount; 
  saleEarning += msg.value;
  saleCounter ++;
  payable(owner).transfer(msg.value);
  emit Transfer(owner, buyer, amount);
}

// set some values for token sale 
function SetpreMintPrice(uint256 price, uint256 _minbuy, uint256 _maxLimit, uint256 _supply) public onlyOwner() 
{
  preMintPrice = price;
  uint256 _conversion = 10 ** _decimal;
  minBuy = _minbuy * _conversion; // 1 token
  maxBuyLimit = _maxLimit * _conversion; // 1 token
  require(Balances[owner] >= _supply * _conversion, "Owner balance is less than pre-mint supply");
  preMintSupply = _supply * _conversion; // 1 token
  preMintSupplyRemaining = preMintSupply;
  saleCounter = 0;
  emit mintDetailsSet(preMintPrice, minBuy, maxBuyLimit, preMintSupply);
  // Chainlink integration and get live eth price is on hold  for now 
}
// set some values for token sale 
// function DummySaleCounter(uint256 _saleCounter) public onlyOwner() 
// {
//   saleCounter = _saleCounter;
// }
}