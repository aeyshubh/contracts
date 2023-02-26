pragma solidity ^0.8.7;
//WA : 0x4F3Df79768ECB9e5094B5737eF274CF4024370e1
contract multisig{

    struct addr{
        address a1;
        address a2;
        bool sts1;
        bool sts2;
        uint256 balance;
    }
    mapping(uint256 => addr) public sign;
    uint256 public index;
    function setSigner(address _a1) public{
            sign[index].a1 = msg.sender;
            sign[index].a2 = _a1;
            index++;
    }

    function SetApproval(uint256 _index) public{
        if(msg.sender == sign[_index].a1 && sign[_index].sts1 == false){
            sign[_index].sts1 = true;
        }else{
    require(msg.sender == sign[_index].a2 && sign[_index].sts2 == false,"You are neither Signer 1 nor 2");
            sign[_index].sts2 = true;
        
        }
    }

    function storeFunds(uint _index) payable external{
        sign[_index].balance = sign[_index].balance + msg.value ;
        
    }

    function withdraw(uint256 _index,address payable _a1) payable public{
        if(sign[_index].sts1 == true && sign[_index].sts1 == true){
            _a1.transfer(sign[_index].balance);
        }
    }
}
