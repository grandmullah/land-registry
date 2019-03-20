pragma solidity ^0.5.4;


contract KCHcoins {
    string public name = "KENYACOIN CASH";
    string public symbol = "kCH";
    uint256 public totalSupply; 

    mapping(address =>uint256)public balanceOf;

    mapping(address=>mapping(address=>uint256))public allowance;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event Approval(
        address indexed _spender,
        address indexed _owner,
        uint256 _value
    );

    constructor (uint256 _initialSupply) public {
      balanceOf[msg.sender] = _initialSupply;
      totalSupply = _initialSupply;
    }

    function TotalSupply() public view returns (uint256 totalsupply) {
        return totalSupply ;
    }

    function BalanceOf(address _owner)public view  returns (uint256 balance) {
        return balanceOf[_owner];      
    }

    function transfer(address _to,uint256 _value)public  returns(bool success) {
        require(balanceOf[msg.sender]>= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        
        emit Transfer(msg.sender,_to,_value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns(bool success)  {
        require(balanceOf[msg.sender] >= _value);
        allowance[msg.sender][_spender] = _value;
        
        emit Approval(_spender,msg.sender,_value);
        return true;
    }

    function transferFrom(address _from,address _to,uint256 _value ) public returns (bool success) {
        require(balanceOf[_from]>=_value);
        require(allowance[_from][msg.sender] >=_value);
        balanceOf[_from] -=_value;
        balanceOf[_to] +=_value;
        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from,_to,_value);

        return true;
    }
    function sendFromTo(address _to,address _from,uint256 _amount)external  returns (bool success) {
        require(balanceOf[_from]>=_amount);
        balanceOf[_from] -= _amount;
        balanceOf[_to] += _amount;
        
        emit Transfer(_from,_to,_amount);
        return true;

    }

}