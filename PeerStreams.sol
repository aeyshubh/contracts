pragma solidity >0.8.0;

contract peerstreams{
   struct subscribedChannels{
        string name;
        address[] subscribedStreamers;//Address of Channels subscribed by a user;
        string[] favouriteVideos;// Links of Nft video collected by the users;
        uint amountDonated;
    }
    struct channel{ // These channels will be mapped as : One streamer will have one Channel 
        string name;
        address[] subscribers;
        string[] videos;
        string bio;
        string twitter;
        string discord;
        string website;

    }
    
    mapping (address => string) public dearStreamers;// Mapping of Streamer's Address and it's Name
    mapping (address => string) public dearUsers;
    mapping(address => channel) public channelOwner;
    mapping(address => subscribedChannels) public  userData;
    
    function createStreamer(string memory name) public{ // Creates a Streamer wallet Address with a Name
        dearStreamers[msg.sender] = name; 
    }

    function createUser(string memory name) public{ // Creates a User wallet Address with a Name
        dearUsers[msg.sender] = name; 
    }

//The below function creates a channel with all necessary details
    function createChannel(string memory cname,string memory _bio,string memory _twitter,string memory _discord,string memory _website) public{
        channelOwner[msg.sender].name = cname;
        channelOwner[msg.sender].bio = _bio;
        channelOwner[msg.sender].twitter = _twitter;
        channelOwner[msg.sender].discord = _discord;
        channelOwner[msg.sender].website = _website;

    }
    //Called when a user Subscribes a streamer 
    function addSubscribersToChannel(address _subscriber) public{
        (channelOwner[msg.sender].subscribers).push(_subscriber);
    }
    // Called when a Streamer adds a Video to his channel i.e the Nft Video Link
    function addVideoToChannel(string memory _videoLink) public{
        (channelOwner[msg.sender].videos).push(_videoLink);
    }

    //Called when a user subscribes a channel
    function subscribeChannel(address _channelAddress) public{ 
        (userData[msg.sender].subscribedStreamers).push(_channelAddress);
    }

    // Called when a user Likes a Video
    function likedVideos(string memory _videoLink) public{ 
        (userData[msg.sender].favouriteVideos).push(_videoLink);
    }
 
      function donate(address payable streamer) public payable returns(uint){
        userData[msg.sender].amountDonated += msg.value;
        streamer.transfer(msg.value);
        return(userData[msg.sender].amountDonated);
    }

    // Getting The Data 
    function getChannelInfo(address _channelAddress) public view returns(string [5]memory){
       string memory a = channelOwner[_channelAddress].name;
       string memory b = channelOwner[msg.sender].bio; 
       string memory c = channelOwner[msg.sender].twitter;
        string memory d = channelOwner[msg.sender].discord;
        string memory e = channelOwner[msg.sender].website;
        string[5] memory data =[a,b,c,d,e];
    return(data); 

    }
//Get Subscribed Channels of Current User
    function getSubscribedChannels() public view returns(address[]memory){
        return(userData[msg.sender].subscribedStreamers);
    }
//Get Liked/Favourite Videos of Current User

    function getLikedVideos() public view returns(string[]memory){
        return(userData[msg.sender].favouriteVideos);
    }
//Get Amount Donated
    function getAmountDonated() public view returns(uint){
        return(userData[msg.sender].amountDonated);
    }
    
}
