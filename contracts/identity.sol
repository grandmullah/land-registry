pragma solidity 0.5.4;


contract Identity {
      
    mapping (address=>string)public id;

    function addid(address _user, string memory ipfshash)public {
       // require(abiencode(keccack256(id[msg.sender])) == abiencode(keccak256("bmb")));
    }
}