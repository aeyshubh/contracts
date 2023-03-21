//SPDX-Licence-Identifier: MIT
pragma solidity 0.8.10;
import {IPool} from "https://github.com/aave/aave-v3-core/blob/master/contracts/interfaces/IPool.sol";
import {IPoolAddressesProvider} from "https://github.com/aave/aave-v3-core/blob/master/contracts/interfaces/IPoolAddressesProvider.sol";
import {ERC20} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract stake {
    address payable owner;
    IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
    IPool public immutable Pool;

    address private immutable EthAddress =
        0xD0dF82dE051244f04BfF3A8bB1f62E1cD39eED92;

    ERC20 private Weth;
    uint256 public totalBalance;

    constructor(address _a) {
        ADDRESSES_PROVIDER = IPoolAddressesProvider(_a);
        Pool = IPool(ADDRESSES_PROVIDER.getPool());
        owner = payable(msg.sender);
        Weth = ERC20(EthAddress);
    }

    function supply(uint256 amount) external {
        address asset = 0xD0dF82dE051244f04BfF3A8bB1f62E1cD39eED92;
        address onBehalfOf = address(this);
        Pool.supply(asset, amount, onBehalfOf, 0);
    }

    function transferW(uint256 _amt) public {
        uint256 bal = this.getBalanceofUser();
        require(bal > _amt, "You don't have enoug Weth to transfer");
        bool sts = Weth.transferFrom(msg.sender, address(this), _amt);
        require(sts, "The transfer was not performed");
        this.supply(_amt);
        _afterTokenTransfer(msg.sender, address(this), _amt);
    }

    function getUserAccountDetails()
        external
        view
        returns (
            uint256 totalCollateralBase,
            uint256 totalDebtBase,
            uint256 availableBorrowBase,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        )
    {
        return Pool.getUserAccountData(address(this));
    }

    function allowanceEth(address _poolContractAddress)
        external
        view
        returns (uint256)
    {
        return Weth.allowance(address(this), _poolContractAddress);
    }

    function getBalance(address _tokenAddress) external view returns (uint256) {
        return ERC20(_tokenAddress).balanceOf(address(this));
    }

    function getBalanceofUser() external view returns (uint256) {
        return Weth.balanceOf(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    //Widthraw WETH Tokens
    function widthrawWeth(uint256 _amt) external payable returns (uint256) {
        address asset = 0xD0dF82dE051244f04BfF3A8bB1f62E1cD39eED92;

        uint256 _currentBalance = UserUinqueId[msg.sender].depositEth;
        require(
            _amt < _currentBalance,
            "Your widthrawl ammount is higher than your current balance"
        );
        require(
            _currentBalance >= UserUinqueId[msg.sender].goalAmount,
            "You have not reached your goal amount yet,keep Pushing"
        );
        UserUinqueId[msg.sender].depositEth =
            UserUinqueId[msg.sender].depositEth -
            _amt;
        totalBalance = totalBalance - _amt;
        return Pool.withdraw(asset, _amt, msg.sender);
    }

    //Claim/Widthraw Intrest bearing tokens
    function widthrawIntrest(uint256 _amt)
        external
        payable
        onlyOwner
        returns (uint256)
    {
        address to = address(this);
        address asset = 0xE1a933729068B0B51452baC510Ce94dd9AB57A11;
        return Pool.withdraw(asset, _amt, to);
    }

    /*     receive() external payable {}
     */

    /* Other section of the smart contract when states are updated */
    struct user {
        uint256 depositEth;
        uint256 timestamp;
        uint256 goalAmount;
    }
    mapping(address => user) public UserUinqueId;
    address[] public poolUsers;

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal {
        UserUinqueId[from].depositEth = UserUinqueId[from].depositEth + amount;
        UserUinqueId[from].timestamp =
            (UserUinqueId[from].timestamp + block.timestamp) /
            2;
        poolUsers.push(from);
        totalBalance = totalBalance + amount;
    }

    function setGoal(uint256 _amt) public {
        UserUinqueId[msg.sender].goalAmount = _amt;
    }

    function getData() public view returns (address[] memory, uint256) {
        uint256 intrestGenerated = (
            ERC20(0xE1a933729068B0B51452baC510Ce94dd9AB57A11).balanceOf(
                address(this)
            )
        ) - totalBalance;
        return (poolUsers, intrestGenerated);
    }

    function sendPrize(address[] memory Winners, uint256[] memory prizes)
        public
        onlyOwner
    {
        uint256 len = Winners.length;
        for (uint256 i = 0; i < len; i++) {
            UserUinqueId[Winners[i]].depositEth += prizes[i];
        }
    }
}
