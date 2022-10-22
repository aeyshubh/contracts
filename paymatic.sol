//SPDX-License-Identifier:Unlicence
// Using Chainling to get realtime price data
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
