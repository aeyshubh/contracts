pragma solidity^ 0.8.0;

contract famtree{
    struct person{
        string maleName;
        string femaleName;
        uint dob;
        uint recordDate;
        uint totalWealth;
        uint genNo;
    }
mapping (address => person[]) PeopleOfFamily;
address [] public headOfFamily; // Array that stores the creator of the tree addresses
function createPerson(string memory _name,string memory _femaleName,uint gen,uint _dob,uint _wealth) public{
   
    PeopleOfFamily[msg.sender].push(person({
        maleName : _name,
        femaleName : _femaleName,
        dob : _dob,
        recordDate: block.timestamp,
        totalWealth : _wealth,
        genNo : gen
    })
    );
    headOfFamily.push(msg.sender);// Push node creating address into the array
}

function getPerson(uint genNo) public view returns(string memory){
    return(PeopleOfFamily[msg.sender][genNo].maleName); // Retrive the generation by the generation Number
}
}
