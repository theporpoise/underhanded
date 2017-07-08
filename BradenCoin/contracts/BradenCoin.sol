pragma solidity ^0.4.11;

contract ERC20Token {
  function balanceOf(address _owner) constant returns (uint256 balance);
  function transfer(address _to, uint _value) returns (bool success);
  function transferFrom(address _from, address _to, uint _value) returns (bool success);
  function approve(address _spender, uint _value) returns (bool success);
  function allowance(address _owner, address _spender) constant returns (uint remaining);
  event Transfer(address indexed _from, address indexed _to, uint _value);
  event Approval(address indexed _owner, address indexed _spender, uint _value);
}

contract owned {
  /**
   * Ownership Contract
   */
  address public owner;

  function owned() {
    owner = msg.sender;
  }

  modifier onlyOwner {
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address newOwner) onlyOwner {
    owner = newOwner;
  }
}

contract mortal is owned {
  /**
   *  Gracefull Killswitch Contract
   */
  function kill() {
    if (msg.sender == owner) {
      selfdestruct(owner);
    }
  }
}


contract BradenCoin is ERC20Token, owned, mortal {
  /**
   * Coin Implementation Contract
   */
  function () {
    throw;
  }

  uint256 public totalSupply;
  mapping(address => uint256) private balances;
  mapping (address => mapping (address => uint256)) private allowances;

  uint256 public buyPrice;
  uint256 public sellPrice;

  function BradenCoin () {
    uint256 initialSupply = 1000000;
    totalSupply = initialSupply;
    balances[this] = initialSupply;
    buyPrice  = 1000000000;
    sellPrice = 1000000000;
  }

  function balanceOf(address _owner) constant returns (uint256 balance) {
    return balances[_owner];
  }

  function transfer(address _to, uint256 _value) returns (bool success) {
    require(balances[msg.sender] >= _value);
    require(balances[_to] + _value > balances[_to]);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    Transfer(msg.sender, _to, _value);
    return true;
  }

  function approve(address _spender, uint _value) returns (bool success) {
    allowances[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  function allowance(address _owner, address _spender)
    constant
    returns (uint remaining)
  {
    return allowances[_owner][_spender];
  }

  function transferFrom(address _from, address _to, uint _value)
    returns (bool success)
  {
    require(balances[_from] >= _value);
    require(allowances[_from][msg.sender] >= _value);
    require(balances[_to] + _value > balances[_to]);
    balances[_from] -= _value;
    allowances[_from][msg.sender] -= _value;
    balances[_to] += _value;
    Transfer(_from, _to, _value);
    return true;
  }

  function mintToken(address _to, uint256 _value)
    onlyOwner
    returns (bool success)
  {
    require(balances[_to] + _value > _value);
    balances[_to] += _value;
    totalSupply += _value;
    Transfer(0x0, owner, _value);
    Transfer(owner, _to, _value);
    return true;
  }

  function burn(uint256 _value) returns (bool success) {
    require(balances[msg.sender] >= _value);
    balances[msg.sender] -= _value;
    totalSupply -= _value;
    Transfer(msg.sender, 0x0, _value);
    return true;
  }

  function burnFrom(address _from, uint _value)
    returns (bool success)
  {
    require(balances[_from] >= _value);
    require(allowances[_from][msg.sender] >= _value);
    balances[_from] -= _value;
    allowances[_from][msg.sender] -= _value;
    totalSupply -= _value;
    Transfer(_from, 0x0, _value);
    return true;
  }

  function setPrice(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
    sellPrice = newSellPrice;
    buyPrice = newBuyPrice;
  }

  function forSale() constant returns (uint256 _amount) {
    return balances[this];
  }

  function buy() payable {
    uint _value = msg.value / buyPrice;
    if (balances[this] >= _value) {
      balances[msg.sender] += _value;
      balances[this] -= _value;
      Transfer(this, msg.sender, _value);
    }
  }

  function sell(uint256 amount) {
    require(balances[msg.sender] >= amount);
    balances[this] += amount;
    balances[msg.sender] -= amount;
    if (!msg.sender.send(amount * sellPrice)) {
      throw;
    } else {
      Transfer(msg.sender, this, amount);
    }
  }


}
