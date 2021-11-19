pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

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
        owner = msg.sender;
        name = _name;
        balance = 0;
    }

    /////////////
    // Getters //
    /////////////

    function getOwner() external view returns (address) {
        return owner;
    }

    function getName() external view returns (string memory) {
        return name;
    }

    function getBalance() external view returns (uint256) {
        return balance;
    }

    function getBounties() external view returns (Bounty[] memory) {
        return bounties;
    }

    /////////////
    // Setters //
    /////////////

    function setOwner(address _owner) external {
        require(msg.sender == owner);
        owner = _owner;
    }

    function setName(string memory _name) public {
        require(msg.sender == owner);
        name = _name;
    }

    function setBalance(uint256 _balance) external {
        balance = _balance;
    }

    function removeBounty(uint256 _index) external {
        require(msg.sender == owner);
        require(bounties.length >= _index);
        delete bounties[_index];
    }

    function addBounty(Bounty memory bounty) public {
        require(msg.sender == owner);
        bounties.push(bounty);
    }
}