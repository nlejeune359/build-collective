pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;
import "./User.sol";

contract Company is User {
    User[] members;
    // tes mon love <3 nicolasadiagas
    constructor(string memory _username) User(_username) public {}

    /////////////
    // Getters //
    /////////////

    function getMembers() external view returns (User[] memory) {
        return members;
    }

    /////////////
    // Setters //
    /////////////

    function removeMember(uint256 _index) external {
        require(members.length >= _index);
        delete members[_index];
    }

    function addMember(User _user) external {
        members.push(_user);
    }
}