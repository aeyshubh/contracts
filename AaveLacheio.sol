//SPDX-License-Identifier: MIT
pragma solidity 0.8.10;
import {IPool} from "https://github.com/aave/aave-v3-core/blob/master/contracts/interfaces/IPool.sol";
import {IPoolAddressesProvider} from "https://github.com/aave/aave-v3-core/blob/master/contracts/interfaces/IPoolAddressesProvider.sol";
import {ERC20} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
contract stake {
    using SafeMath for uint256;
    address payable owner;
    IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
    IPool public immutable Pool;
    address private immutable EthAddress =
        0xD0dF82dE051244f04BfF3A8bB1f62E1cD39eED92;

    ERC20 private Weth;
    uint256 public totalBalance;
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }
    constructor(address _a) {
        ADDRESSES_PROVIDER = IPoolAddressesProvider(_a);
        Pool = IPool(ADDRESSES_PROVIDER.getPool());
        owner = payable(msg.sender);
        Weth = ERC20(EthAddress);
        myBirthday = block.timestamp;
    }

    function supply(uint256 amount) internal {
        address _poolContractAdddress = 0xE7EC1B0015eb2ADEedb1B7f9F1Ce82F9DAD6dF08;
        Weth.approve(_poolContractAdddress, amount);
        address asset = 0xD0dF82dE051244f04BfF3A8bB1f62E1cD39eED92;
        address onBehalfOf = address(this);
        Pool.supply(asset, amount, onBehalfOf, 0);
    }

    function transferW(uint256 _amt,uint256 _goalAmt) public {
        (UserUinqueId[msg.sender].goalAmount == 0)?UserUinqueId[msg.sender].goalAmount = _goalAmt:1;
        Weth.transferFrom(msg.sender, address(this), _amt);
        supply(_amt);
        _afterTokenTransfer(msg.sender, _amt);
    }

    function allowanceEth(address _poolContractAddress)
        external
        view
        returns (uint256)
    {
        return Weth.allowance(address(this), _poolContractAddress);
    }
//Returns the balance of the given token Address @dev only for the contract
    function getBalanceofContract(address _tokenAddress) external view returns (uint256) {
        return ERC20(_tokenAddress).balanceOf(address(this));
    }
//Returns the balance of the given token Address @dev only for the User
    function getBalanceofUser(address _tokenAddress) external view returns (uint256) {
        return ERC20(_tokenAddress).balanceOf(msg.sender);
    }

    //Widthraw WETH Tokens
    function widthrawWeth(uint256 _amt) external returns (uint256) {
        address asset = 0xD0dF82dE051244f04BfF3A8bB1f62E1cD39eED92; //WETH address
        uint256 _currentBalance = UserUinqueId[msg.sender].depositEth;
        require(
            _amt <= _currentBalance,
            "Your widthrawl ammount is higher than your current balance"
        );
        require(
            _currentBalance >= UserUinqueId[msg.sender].goalAmount,
            "You have not reached your goal amount yet,keep Pushing"
        );
        UserUinqueId[msg.sender].depositEth =
            SafeMath.sub(UserUinqueId[msg.sender].depositEth,_amt);
        totalBalance = SafeMath.sub(totalBalance,_amt);
        UserUinqueId[msg.sender].goalAmount = 0;
        if(UserUinqueId[msg.sender].depositEth == 0){
             for(uint i = 0; i < poolUsers.length-1; i++){
                 if(poolUsers[i] == msg.sender){
                     delete poolUsers[i];
                 }
                          
    }
        }
        return Pool.withdraw(asset, _amt, msg.sender);
    }

address private eoa = 0xB6D3937B425b0EfeBAA97A97F906652688c301d5;
    function widthrawIntrestToTreasury(uint256 _amt) public onlyOwner returns(bool){

    }

    /* Other section of the smart contract when states are updated */
    struct user {
        uint256 depositEth;
        uint256 timestamp;
        uint256 goalAmount;
        uint256 prizeMoney;
    }

    struct winners{
        address w;
        uint256 p;
    }
uint256 public _lastWinnerIndex;
mapping(uint256 => winners) public lastWinners;
mapping(address =>uint256) public Winners; //This mapping will track of winners 
uint256 public myBirthday;
    mapping(address => uint256) public _depositors;
    mapping(address => user) public UserUinqueId;
    address[] public poolUsers;
    //called after the tokens are deposited into the pool
    /* @dev if the current timestamp is 0 then we will add the new current timestamp  
        if a older timestamp already exists then we will take average of both the timestamps and update
*/

    function _afterTokenTransfer(
        address from,
        uint256 amount
    ) internal {
        if(UserUinqueId[from].depositEth == 0){poolUsers.push(from);}
         UserUinqueId[from].depositEth = SafeMath.add(UserUinqueId[from].depositEth,amount);
        (UserUinqueId[from].timestamp == 0)?UserUinqueId[from].timestamp = block.timestamp: SafeMath.div(SafeMath.add(UserUinqueId[from].timestamp,block.timestamp),2);
        _depositors[from] = amount;
        totalBalance = SafeMath.add(totalBalance,amount);
    }

    function getData() public view returns (address[] memory, uint256) {
        uint256 intrestGenerated = SafeMath.sub((ERC20(0xE1a933729068B0B51452baC510Ce94dd9AB57A11).balanceOf(address(this))),totalBalance);
        return (poolUsers, intrestGenerated);
    }

    function sendPrize(bytes memory _str)
        public
        onlyOwner
    {
        address[] memory ws;
        uint256[] memory prizes;
        uint256 treasuryAmt;
        (ws,prizes,treasuryAmt) = abi.decode(_str,(address[],uint256[],uint));
        address asset = 0xE1a933729068B0B51452baC510Ce94dd9AB57A11;//Aweth TOKEN
        ERC20(asset).transfer(eoa,treasuryAmt);
        for (uint256 i = 0; i < ws.length; i++) {
            //The below will store all the winners of the draw
            Winners[ws[i + _lastWinnerIndex]] = Winners[ws[i]] + prizes[i]; 
            lastWinners[i].w = ws[i]; // Can give only the last 5 winners of the draw
            lastWinners[i].p = prizes[i]; 
            ERC20(asset).transfer(ws[i],prizes[i]);
            UserUinqueId[ws[i]].prizeMoney += prizes[i];
        }
            _lastWinnerIndex += 5;
    }
}
