pragma solidity >=0.4.22 <0.9.0;
import "./Project.sol";

contract User {
    string name;
    uint256 balance;
    Project[] projects;
    bool registered;

    constructor(string memory _name) public {
        name = _name;
        balance = 0;
        registered = true;
    }

    function setRegistered(bool _registered) public {
        registered = _registered;
    }

    function isRegistered() public returns (bool) {
        return registered;
    }

    function addBalance(uint256 _amount) public {
        balance += _amount;
    }
}