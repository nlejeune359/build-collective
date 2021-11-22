pragma solidity >=0.4.22 <0.9.0;
import "./Project.sol";

contract User {
    string username;
    uint256 balance;
    Project[] projects;
    bool registered;

    constructor(string memory _username) public {
        username = _username;
        balance = 0;
        registered = true;
    }

    /////////////
    // Getters //
    /////////////

    function getUsername() external view returns (string memory) {
        return username;
    }

    function getBalance() external view returns (uint256) {
        return balance;
    }

    function getProjects() external view returns (Project[] memory) {
        return projects;
    }

    function getProject(uint256 _index) external view returns (Project) {
        return projects[_index];
    }

    function isRegistered() external view returns (bool) {
        return registered;
    }

    /////////////
    // Setters //
    /////////////

    function setUsername(string memory _username) public {
        username = _username;
    }

    function setBalance(uint256 _balance) external {
        balance = _balance;
    }

    function removeProject(uint256 _index) external {
        require(projects.length >= _index);
        delete projects[_index];
    }

    function addProject(Project _project) external {
        projects.push(_project);
    }
    
    function setRegistered(bool _registered) external {
        registered = _registered;
    }


    function addBalance(uint256 _amount) external {
        balance += _amount;
    }
}