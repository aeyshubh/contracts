//SPDX-License-Identifier:Unlicence
// Using Chainling to get realtime price data
//Address = 0x6187EAcE04480e40692a003D39804d56a708136b
//ABI :[
	{
		"inputs": [],
		"name": "buySubscription",
		"outputs": [],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "buyerAddress",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "time",
				"type": "uint256"
			}
		],
		"name": "subsBought",
		"type": "event"
	},
	{
		"inputs": [],
		"name": "getLatestPrice",
		"outputs": [
			{
				"internalType": "int256",
				"name": "",
				"type": "int256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]
pragma solidity^ 0.8.7;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
contract PriceConsumerV3 {

    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Polygon
     * Aggregator: Matic/USD
     * Address: 0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada
     */
    address payable contractOwner;
    event subsBought(address buyerAddress,uint256 time);

    constructor(){
        priceFeed = AggregatorV3Interface(0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada);
        contractOwner = payable(msg.sender);
    }

    function getLatestPrice() public view returns (int) {
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return (price);
    }

    function buySubscription() public payable{
        require(msg.value>0,"Can't pay with 0 Matic");
        emit subsBought(msg.sender,block.timestamp);
    }


    

}
