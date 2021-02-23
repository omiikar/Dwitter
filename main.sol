pragma solidity ^0.8.0;

contract Dwitter{
    
    address owner;

    struct Users{
        address User_ID;
        string Name;
        address followers;
        address following;
        uint count_follower;
        uint count_following;
        uint pin;
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

//--------------------------------User Data Management--------------------------------    

    function signUp(string memory _Name, uint _pin)public{
        require(user[msg.sender].User_ID == address(0),"User Already Registered");
        user[msg.sender].User_ID=msg.sender;
        user[msg.sender].Name=_Name;
        user[msg.sender].pin=_pin;
        user[msg.sender].account_status=true;
        user[msg.sender].count_following=0;
        user[msg.sender].count_follower=0;
        emit Login("User Registered Successfully");
    }
    
    function signIn(uint _pin)public{
        require(user[msg.sender].User_ID == msg.sender,"User Not Registered");
        require(user[msg.sender].pin == _pin,"Invalid PIN" );
        user[msg.sender].log=true;
        emit Login("Login Successful");
    }
    
    function viewUserProfile() public view returns(address,string memory,bool,uint,uint){
        require(user[msg.sender].account_status == true,"Account Deactivated..Access Denied!!");
        return(user[msg.sender].User_ID,user[msg.sender].Name,user[msg.sender].verified,user[msg.sender].count_follower,user[msg.sender].count_following);
    }
    
    function searchUserProfile(address _search_user) public view returns(address,string memory,bool,uint,uint){
        require(user[_search_user].account_status == true,"User's Account Deactivated");
        return(user[_search_user].User_ID,user[_search_user].Name,user[_search_user].verified,user[_search_user].count_follower, user[_search_user].count_following);
    }
    
    function changeAccountStatus()public{
        user[msg.sender].account_status = !user[msg.sender].account_status;
        emit Login("Account Deactivated");
    }
    
    
    
    function deleteMyAccount() public{
        delete user[msg.sender];
        emit Login("Account Deleted");
    }
    
    function verifyAccount(address _user_to_verfiy) public onlyOwner{
        user[_user_to_verfiy].verified = true;
    }
    
//--------------------------------User Data Management--------------------------------    

    mapping(address=>string[])tweets;
    mapping(address=>string[])hashTag;
    
    mapping(address=>string[])like;
    mapping(address=>string[])retweet;
    mapping(address=>string[])report;
    
    function tweet(string memory _tweet,string memory _hashTag)public {
        tweets[msg.sender].push(_tweet);
        hashTag[msg.sender].push(_hashTag);
        emit Login("Tweet Successful");
    }
    
    function showTweets(address _user_address, uint _uid)public view returns(string[] memory) {
        return tweets[_user_address];
    }
    
    function follow(address _user_address)public{
        user[_user_address].count_follower+=1;
        user[msg.sender].count_following+=1;
        
        user[_user_address].followers = msg.sender;
        user[msg.sender].following = _user_address;
    }
    
}
