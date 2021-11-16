pragma solidity >=0.4.22 <0.9.0;

contract Project {
    
    struct Bounty {
        uint256 reward;
        bool closed;
    }

    address owner;
    string name;
    uint256 balance;
    Bounty[] bounties;

    constructor(string memory _name) public {
        name = _name;
        balance = 0;
    }
}