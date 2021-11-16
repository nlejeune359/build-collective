pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";
import "./User.sol";
import "./Company.sol";

contract BuildCollective is Ownable {

  /////////////////
  // Definitions //
  /////////////////

  mapping(address => User) public users;
  mapping(address => Company) public companies;

  ////////////
  // Events //
  ////////////

  event UserSignedUp(address indexed userAddress, User indexed user);
  event CompanySignedUp(address indexed userAddress, Company indexed company);
  event UserSignedOut(address indexed userAddress);
  event CompanySignedOut(address indexed userAddress);

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

  function signUpCompany(string memory _name) public returns (Company) {
    require(bytes(_name).length > 0);
    
    companies[msg.sender] = new Company(_name);
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

  function addBalance(uint256 _amount) public returns (bool) {
    require(users[msg.sender].isRegistered());

    users[msg.sender].addBalance(_amount);
    return true;
  }
}
