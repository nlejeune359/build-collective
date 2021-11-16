pragma solidity >=0.4.22 <0.9.0;
import "./User.sol";

contract Company is User {
    User[] members;
    // tes mon love <3 nicolasadiagas
    constructor(string memory _name) User(_name) public {}


}