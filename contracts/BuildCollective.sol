pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";
// import "./User.sol";
// import "./Company.sol";
// import "./Project.sol";

contract BuildCollective is Ownable {

  /////////////////
  // Definitions //
  /////////////////

  struct User {
    string username;
    uint256 balance;
    // Project[] projects;
    bool registered;
  }

  struct Company {
    string username;
    uint256 balance;
    // User[] members;
    // Project[] projects;
    bool registered;
  }

  struct Bounty {
    uint256 reward;
    bool closed;
  }

  struct Project {
    uint id;
    address owner;
    string name;
    uint256 balance;
    // Bounty[] bounties;
  }

  mapping(address => User) public users;
  mapping(address => Company) public companies;
  mapping(address => Project[]) public projects;
  mapping(address => User[]) public members;
  mapping(uint => Bounty[]) public bounties;

  uint count = 0;

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

  function user(address userAddress) public view returns (User memory) {
    return users[userAddress];
  }

  function company(address companyAddress) public view returns (Company memory) {
    return companies[companyAddress];
  }

  ///////////////
  // Functions //
  ///////////////

  /** Connection */

  function signUpCompany(string memory _username) public returns (Company memory) {
    require(bytes(_username).length > 0);
    
    companies[msg.sender] = Company(_username, 0, true);
    emit CompanySignedUp(msg.sender, companies[msg.sender]);
  }

  function signUp(string memory _username) public returns (User memory) {
    require(bytes(_username).length > 0);

    User memory u;
    u.username = _username;
    u.balance = 0;
    u.registered = true;

    users[msg.sender] = u;
    emit UserSignedUp(msg.sender, users[msg.sender]);
  }

  function signOut() public returns (bool) {
    require(users[msg.sender].registered);
    
    users[msg.sender].registered = false;
    emit UserSignedOut(msg.sender);
    return true;
  }

  // function signOutCompany() public returns (bool) {
  //   require(companies[msg.sender].registered);
    
  //   companies[msg.sender].registered = false;
  //   emit CompanySignedOut(msg.sender);
  //   return true;
  // }

  /** Transactions */

  function addBalance(uint256 _amount) public returns (bool) {
    require(users[msg.sender].registered);

    users[msg.sender].balance += _amount;
    return true;
  }

  /** Projects */

  // function getProjects() public returns (Project[] memory) {
  //   require(users[msg.sender].isRegistered());

  //   return users[msg.sender].getProjects();
  // }

  // function createProject(string memory _name) public returns (bool) {
  //   require(users[msg.sender].isRegistered());

  //   users[msg.sender].addProject(new Project(_name));
  //   return true;
  // }

  // function removeProject(uint256 _index) public returns (bool) {
  //   require(users[msg.sender].isRegistered());

  //   users[msg.sender].removeProject(_index);
  //   return true;
  // }

  // function addContributorToProject(uint256 _index, address _contributor) public returns (bool) {
  //   require(users[msg.sender].getProject(_index).getOwner() == msg.sender);
  //   // require(users[_contributor]);

  //   users[_contributor].addProject(users[msg.sender].getProject(_index));
  //   return true;
  // }
}