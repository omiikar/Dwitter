pragma solidity ^0.8.0;

contract Dwitter{
    
    address owner;

    struct Users{
        address User_ID;
        string Name;
        uint8 pin;
        bool log;
        bool verified;
        bool account_status;
    }
    
  
    mapping(address=>Users) user; 

    
    event Login(string msg);
    
    modifier onlyOwner(){
        require (owner == msg.sender, "Access Denied");
        _;
    }
    
    constructor(){
        owner = msg.sender;
    }
    
    function signUp(string memory _Name, uint8 _pin)public{
        require(user[msg.sender].User_ID == address(0),"User Already Registered");
        user[msg.sender].User_ID;
        user[msg.sender].Name;
        user[msg.sender].pin;
        emit Login("User Registered Successfully");
    }
    
    function signIn(uint8 _pin)public{
        require(user[msg.sender].User_ID != address(0),"User Not Registered");
        require(user[msg.sender].pin != _pin,"Invalid PIN" );
        user[msg.sender].log=true;
        emit Login("Login Successful");
    }
    
    function viewUserProfile() public view returns(address,string memory,bool){
        require(user[msg.sender].account_status == true,"Account Deactivated..Access Denied!!");
        return(user[msg.sender].User_ID,user[msg.sender].Name,user[msg.sender].verified);
    }
    
    function changeAccountStatus()public{
        user[msg.sender].account_status = !user[msg.sender].account_status;
        emit Login("Account Deactivated");
    }
    
    function searchUserProfile(address _search_user) public view returns(address,string memory,bool){
        require(user[_search_user].account_status == true,"User's Account Deactivated");
        return(user[_search_user].User_ID,user[_search_user].Name,user[_search_user].verified);
    }
    
    function deleteMyAccount() public{
        delete user[msg.sender];
    }
    
    function verifyAccount(address _user_to_verfiy) public{
        require(msg.sender == owner, "Access Denied..!! Not Owner");
        user[_user_to_verfiy].verified = true;
    }
    
}
