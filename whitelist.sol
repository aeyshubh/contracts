//SPDX-License-Identifier: Unlicense

pragma solidity^ 0.8.10;

contract whitelist{
    // Max number of white listed address
    uint8 maxWhiteListedAddress;
//if a address is whitelisted we will set it to true else we will set it to false,by default all the address will be false
    mapping(address => bool) public whiteListedAddress;
// Used to check how many address are being shortlisted
    uint8 public numWhiteListedAddress;

    //Enter value of max white listed address value
    constructor(uint8 _maxWAddres){
        maxWhiteListedAddress = _maxWAddres;
    }

    //
    function addAddressToWhitelist() public {
        //Check if the user has been already White Listed 
        require(!whiteListedAddress[msg.sender],"You are already White Listed");
        // Max number of users WhiteListed
        require(numWhiteListedAddress < maxWhiteListedAddress,"Max Limit reached for Listing");
        whiteListedAddress[msg.sender] = true;
        numWhiteListedAddress +=1;

    }


}
