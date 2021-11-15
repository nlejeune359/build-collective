pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";

contract BuildCollective is Ownable {

  /////////////////
  // Definitions //
  /////////////////

  struct User {
    string name;
    uint256 balance;
    bool registered;
  }

  struct Company {
    string name;
    User owner;
    User[] members;
    Project[] projects;    
  }

  struct Project {
    User ownerUser;
    Company ownerCompany;
    string name;
    uint256 balance;
    User[] contributors;
    Bounty[] bounties;
  }

  struct Bounty {
      uint256 reward;
      bool closed;
  }

  mapping(address => User) private users;
  mapping(address => Company) private companies;

  event UserSignedUp(address indexed userAddress, User indexed user);
  event CompanySignedUp(address indexed userAddress, Company indexed company);

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

  function signUp(string memory name, bool isCompany) public returns (User memory) {
    require(bytes(name).length > 0);

    if(isCompany) {
      companies[msg.sender] = Company(name, msg.sender, [], []);
      emit CompanySignedUp(msg.sender, companies[msg.sender]);
    } else {
      users[msg.sender] = User(username, 0, true);
      emit UserSignedUp(msg.sender, users[msg.sender]);
    }
  }

  function addBalance(uint256 amount) public returns (bool) {
    require(users[msg.sender].registered);
    users[msg.sender].balance += amount;
    return true;
  }

  // function openBounty(uint256 reward) {
  //   require(msg.sender == owner.owner);
  // }
}
