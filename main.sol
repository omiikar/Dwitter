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
    
    modifier checkLogin(){
        require (user[msg.sender].log==true, "Please Login your account");
        require(user[msg.sender].account_status == true,"Account Deactivated..Access Denied!!");
        _;
    }
    
    modifier stopOwner{
        require (user[msg.sender].User_ID==msg.sender, "Owner Cannot Modifiy Data");
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
    
    function viewUserProfile() public checkLogin view returns(address,string memory,bool,uint,uint){
        return(user[msg.sender].User_ID,user[msg.sender].Name,user[msg.sender].verified,user[msg.sender].count_follower,user[msg.sender].count_following);
    }
    
    function searchUserProfile(address _search_user) public checkLogin view returns(address,string memory,bool,uint,uint){
        return(user[_search_user].User_ID,user[_search_user].Name,user[_search_user].verified,user[_search_user].count_follower, user[_search_user].count_following);
    }
    
    function changeAccountStatus()public checkLogin{
        user[msg.sender].account_status = !user[msg.sender].account_status;
        emit Login("Account Status Changed");
    }
    
    
    
    function deleteMyAccount() public checkLogin{
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
    
    function tweet(string memory _tweet,string memory _hashTag)public checkLogin{
        tweets[msg.sender].push(_tweet);
        hashTag[msg.sender].push(_hashTag);
        emit Login("Tweet Successful");
    }
    
    function showTweets(address _user_address)public checkLogin view returns(string[] memory) {
        return tweets[_user_address];
    }
    
    function follow(address _user_address)public checkLogin{
        user[_user_address].count_follower+=1;
        user[msg.sender].count_following+=1;
        
        user[_user_address].followers = msg.sender;
        user[msg.sender].following = _user_address;
    }
       
    function likeTweets(address _user_address,uint tweet_UID)public checkLogin{
        string[] memory showingTweets;
        showingTweets = showTweets(_user_address);
        like[msg.sender].push(showingTweets[tweet_UID]);
    }
    
    function reTweets(address _user_address,uint tweet_UID)public checkLogin stopOwner{
        string[] memory showingReTweets;
        showingReTweets = showTweets(_user_address);
        retweet[msg.sender].push(showingReTweets[tweet_UID]);
    }
    
    function showReTweets(address _user_address)public checkLogin view returns(string[] memory){
        return retweet[_user_address];
    }
    
    function showLikes(address _user_address)public checkLogin view returns(string[] memory){
        return like[_user_address];
    }
}
