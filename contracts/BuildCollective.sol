pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";
import "./User.sol";
import "./Company.sol";
import "./Project.sol";

contract BuildCollective is Ownable {

  /////////////////
  // Definitions //
  /////////////////

  mapping(address => User) public users;
  mapping(address => Company) public companies;

  ////////////
  // Events //
  ////////////

  /** Connection */
  event UserSignedUp(address indexed userAddress, User indexed user);
  event CompanySignedUp(address indexed userAddress, Company indexed company);
  event UserSignedOut(address indexed userAddress);
  event CompanySignedOut(address indexed userAddress);

  /** Projects */
  // event NewProjectCreated(address indexed userAddress, Project indexed project);

  /////////////
  // Getters //
  /////////////

  function user(address userAddress) public view returns (User) {
    return users[userAddress];
  }

  function company(address companyAddress) public view returns (Company) {
    return companies[companyAddress];
  }

  ///////////////
  // Functions //
  ///////////////

  /** Connection */

  function signUpCompany(string memory _username) public returns (Company) {
    require(bytes(_username).length > 0);
    
    companies[msg.sender] = new Company(_username);
    emit CompanySignedUp(msg.sender, companies[msg.sender]);
  }

  function signUp(string memory _username) public returns (User) {
    require(bytes(_username).length > 0);

    users[msg.sender] = new User(_username);
    emit UserSignedUp(msg.sender, users[msg.sender]);
  }

  function signOut() public returns (bool) {
    require(users[msg.sender].isRegistered());
    
    users[msg.sender].setRegistered(false);
    emit UserSignedOut(msg.sender);
    return true;
  }

  function signOutCompany() public returns (bool) {
    require(companies[msg.sender].isRegistered());
    
    companies[msg.sender].setRegistered(false);
    emit CompanySignedOut(msg.sender);
    return true;
  }

  /** Transactions */

  function addBalance(uint256 _amount) public returns (bool) {
    require(users[msg.sender].isRegistered());

    users[msg.sender].addBalance(_amount);
    return true;
  }

  /** Projects */

  function getProjects() public returns (Project[] memory) {
    require(users[msg.sender].isRegistered());

    return users[msg.sender].getProjects();
  }

  function createProject(string memory _name) public returns (bool) {
    require(users[msg.sender].isRegistered());

    users[msg.sender].addProject(new Project(_name));
    return true;
  }

  function removeProject(uint256 _index) public returns (bool) {
    require(users[msg.sender].isRegistered());

    users[msg.sender].removeProject(_index);
    return true;
  }

  function addContributorToProject(uint256 _index, address _contributor) public returns (bool) {
    require(users[msg.sender].getProject(_index).getOwner() == msg.sender);
    // require(users[_contributor]);

    users[_contributor].addProject(users[msg.sender].getProject(_index));
    return true;
  }
}