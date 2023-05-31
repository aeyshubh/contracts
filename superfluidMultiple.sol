//SPDX-License-Identifier : MIT
pragma solidity ^0.8.14;
//0x438d0Fc2C241aCE1BC76116B8818aaeF44f3daB8
//TOken : 0x5D8B4C2554aeB7e86F387B4d6c00Ac33499Ed01f
import {ISuperfluid, ISuperToken, ISuperApp} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";

import {SuperTokenV1Library} from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperTokenV1Library.sol";

contract safex {
    using SuperTokenV1Library for ISuperToken;
    address addr;

    constructor() {
        addr = address(this);
    }

    struct salary {
        uint256 salaryAmount;
        int96 Flowrate;
        string name;
        address receiver;
    }

    struct txdetail {
        uint256[] timestamp;
        string[] txhash;
    }
    mapping(address => mapping(uint256 => salary)) public salaryMapping;
    mapping(address => uint256) public index;
    mapping(address => txdetail) txMapping;
    ISuperToken public token;

    function setSalaryInfo(
        address _receiver,
        string memory _name,
        int96 _flowrate,
        uint256 _salary,
        uint256 _id
    ) public {
        if (_id != 0) {
            uint256 tempIndex = _id;
            salaryMapping[msg.sender][tempIndex].receiver = _receiver;
            salaryMapping[msg.sender][tempIndex].name = _name;
            salaryMapping[msg.sender][tempIndex].Flowrate = _flowrate;
            salaryMapping[msg.sender][tempIndex].salaryAmount = _salary;
        } else {
            uint256 tempIndex = index[msg.sender];
            salaryMapping[msg.sender][tempIndex].receiver = _receiver;
            salaryMapping[msg.sender][tempIndex].name = _name;
            salaryMapping[msg.sender][tempIndex].Flowrate = _flowrate;
            salaryMapping[msg.sender][tempIndex].salaryAmount = _salary;
            index[msg.sender] = ++tempIndex;
        }
    }

    function createMultipleStreams(ISuperToken token) public {
       unchecked{
        for (uint256 i = 0; i < index[msg.sender]; i++) {
            address receiver = salaryMapping[msg.sender][i].receiver;
            int96 flowrate = salaryMapping[msg.sender][i].Flowrate;
            token.createFlow(receiver, flowrate);
        }
       }
    }

    function deleteMultipleStreams(ISuperToken token) public {
       unchecked{
        for (uint256 i = 0; i < index[msg.sender]; i++) {
            address receiver = salaryMapping[msg.sender][i].receiver;
            token.deleteFlow(addr, receiver);
        }
       }
    }

    function storeTransaction(string memory _tx) public {
        txMapping[msg.sender].timestamp.push(block.timestamp);
        txMapping[msg.sender].txhash.push(_tx);
    }

    function getTransactions()
        public
        view
        returns (uint256[] memory, string[] memory)
    {
        return (txMapping[msg.sender].timestamp, txMapping[msg.sender].txhash);
    }
}
