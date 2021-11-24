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
    uint id;
    string nom;
    string description;
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

  uint countProject = 0;
  uint countBounty = 0;

  ////////////
  // Events //
  ////////////

  /** Connection */
  event UserSignedUp(address indexed userAddress, User indexed user);
  event UserSignedOut(address indexed userAddress);
  event CompanySignedUp(address indexed companyAddress, Company indexed company);
  event CompanySignedOut(address indexed companyAddress);

  event ProjectCreated(address indexed userAddress, Project indexed project);
  event ProjectRemoved(address indexed userAddress, uint indexed index, Project indexed project);
  event ContributorAddedToProject(address indexed userAddress, Project indexed project);

  event BountyCreated(uint indexed idProject, Bounty indexed bounty);
  event BountyRemoved(uint indexed idProject, Bounty indexed bounty);
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
    return companies[msg.sender];
  }

  function signUp(string memory _username) public returns (User memory) {
    require(bytes(_username).length > 0);

    users[msg.sender] = User(_username, 0, true);
    emit UserSignedUp(msg.sender, users[msg.sender]);
    return users[msg.sender];
  }

  function signOut() public returns (bool) {
    require(users[msg.sender].registered);
    
    users[msg.sender].registered = false;
    emit UserSignedOut(msg.sender);
    return true;
  }

  function signOutCompany() public returns (bool) {
    require(companies[msg.sender].registered);
    
    companies[msg.sender].registered = false;
    emit CompanySignedOut(msg.sender);
    return true;
  }

  /** Transactions */

  function addBalance(uint256 _amount) public returns (bool) {
    require(users[msg.sender].registered);

    users[msg.sender].balance += _amount;
    return true;
  }

  /** Projects */

  function getProjectIndex(address _userAddress, uint _id) private view returns (uint) {
    Project[] memory p = projects[_userAddress];
    for(uint i=0; i < p.length; i++) {
      if (p[i].id == _id) {
        return i;
      }
    }
    revert("Project at this index does not exist");
  }

  function getProjects() public view returns (Project[] memory) {
    require(users[msg.sender].registered);

    return projects[msg.sender];
  }

  function createProject(string memory _name) public returns (Project memory) {
    require(users[msg.sender].registered);

    projects[msg.sender].push(Project(countProject, msg.sender, _name, 0));
    countProject++;
    uint index = projects[msg.sender].length - 1;
    emit ProjectCreated(msg.sender, projects[msg.sender][index]);
    return projects[msg.sender][index];
  }

  function removeProject(uint256 _id) public returns (Project[] memory) {
    require(users[msg.sender].registered);

    uint index = getProjectIndex(msg.sender, _id);

    Project memory project = projects[msg.sender][index];
    delete projects[msg.sender][index];
    emit ProjectRemoved(msg.sender, index, project);
    return projects[msg.sender];
  }

  function addContributorToProject(uint256 _id, address _contributor) public returns (bool) {
    require(_id >= 0 && _id < projects[msg.sender].length);
    // require(users[_contributor].amount != 0);
    require(projects[msg.sender][_id].owner == msg.sender);
    // require(users[_contributor]);

    uint index = getProjectIndex(msg.sender, _id);
    Project memory p = projects[msg.sender][index];
    projects[_contributor].push(p);
    return true;
  }

  /** Bounties */

  function getBounties(uint _idProject) public view returns (Bounty[] memory) {
    return bounties[_idProject];
  }

  function createBounty(uint _idProject, string memory _nom, string memory _description, uint _reward) public returns (Bounty memory) {
    require(users[msg.sender].registered);
    require(projects[msg.sender][_idProject].owner == msg.sender);

    bounties[_idProject].push(Bounty(countBounty, _nom, _description, _reward, false));
    emit BountyCreated(countBounty, bounties[_idProject][bounties[_idProject].length - 1]);
    countBounty++;

    return bounties[_idProject][bounties[_idProject].length - 1];
  }

  function getBountyIndex(uint _idProject, uint _id) private view returns (uint) {
    Bounty[] memory b = bounties[_idProject];
    for(uint i=0; i < b.length; i++) {
      if (b[i].id == _id) {
        return i;
      }
    }
    revert("Bounty at this index does not exist");
  }

  function removeBounty(uint _idProject, uint _id) public returns (bool) {
    require(users[msg.sender].registered);
    require(projects[msg.sender][_idProject].owner == msg.sender);

    uint index = getBountyIndex(_idProject, _id);

    Bounty memory bounty = bounties[_idProject][index];
    delete bounties[_idProject][index];
    emit BountyRemoved(index, bounty);
    return true;
  }

  function closeBounty(uint _idProject, uint _id) public returns (bool) {
    require(users[msg.sender].registered);
    require(projects[msg.sender][_idProject].owner == msg.sender);
    require(!bounties[_idProject][_id].closed);

    bounties[_idProject][_id].closed = true;
    return true;
  }

  function openBounty(uint _idProject, uint _id) public returns (bool) {
    require(users[msg.sender].registered);
    require(projects[msg.sender][_idProject].owner == msg.sender);
    require(bounties[_idProject][_id].closed);

    bounties[_idProject][_id].closed = false;
    return true;
  }
}
