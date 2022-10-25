// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/utils/math/SafeMath.sol";

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}
// vesting contract interface
interface IVesting {
    function setVestingAllocation(uint256) external;
    function addNewRecipient(address, uint256, bool) external;
    function startVesting(uint256) external;
    function getLocked(address) external view returns (uint256);
    function getWithdrawable(address) external view returns (uint256);
    function withdrawToken(address) external returns (uint256);
    function getVested(address) external view returns (uint256);
}

contract TokenPreSale is Ownable {
    using SafeMath for uint256;
    // address of admin
    IERC20 public token;
    // token price variable
    uint256 public tokenchangeRate;
    // count of token sold vaariable
    uint256 public totalsold; 

    uint256 public START; // start ICO time blocktime 
    uint256 public PERIOD; // During Days days
    bool public endStatus = false;

    IVesting private vestingContract; // Vesting Contract
    
    /// presalebuyer object
    struct PresaleBuyer {
        uint256 amountDepositedAVAX; // Avax amount per recipient.
        uint256 amountCCoin; // Rewards token that needs to be vested.
    }

    mapping(address => PresaleBuyer) public recipients; // Presale Buyers


    event Sell(address sender,uint256 totalvalue); 
    
    function setVestingContractAddress(address _vestingContract) external onlyOwner {
        require (_vestingContract != address(0x00));
        vestingContract = IVesting(_vestingContract);
    }
    /**
    * whenSaleIsActive
    * @dev ensures that the contract is still active
    **/
    modifier whenSaleIsActive() {
        // Check if sale is active
        assert(isActive());
        _;
    }
    // constructor 
    constructor(address _tokenaddress, uint _tokenChangeRate, uint _startTime, uint _duringDays){
        tokenchangeRate = _tokenChangeRate;
        token  = IERC20(_tokenaddress);
        START = _startTime;
        PERIOD = _duringDays;
    }
   
    // buyTokens function
    function buyTokens() public whenSaleIsActive payable {
        address buyer = msg.sender;
        uint256 avaxAmount = msg.value;

        // check if the contract has the tokens or not
        // require(token.balanceOf(address(vestingContract)) >= avaxAmount * tokenchangeRate,'the smart contract dont hold the enough tokens');
        require(address(vestingContract) != address(0x00), "Withdraw: Set vesting contract!");

        uint256 newDepositedAvax = recipients[msg.sender].amountDepositedAVAX.add(avaxAmount);
        uint256 newDepositedCCoin = avaxAmount.mul(tokenchangeRate).div(1000);
 
        recipients[msg.sender].amountDepositedAVAX = newDepositedAvax;
        recipients[msg.sender].amountCCoin = recipients[msg.sender].amountCCoin.add(newDepositedCCoin);
        vestingContract.addNewRecipient(msg.sender, recipients[msg.sender].amountCCoin, true);

        // // transfer the token to the user
        // token.transfer(buyer, avaxAmount * tokenchangeRate);
        // increase the token sold
        totalsold += newDepositedCCoin;
        // emit sell event for ui
        emit Sell(buyer, newDepositedCCoin);
    }
    // get avax amount from current user
    function getAvaxBal(address _addr) public view returns(uint256) {
        return address(_addr).balance;
    }

    // view native token (avax) amount on this contract
    function getBalanceofAvax() public view returns (uint256) {
        return address(this).balance;
    }

    function getCurrentTime() public view returns(uint256) {
        return block.timestamp;
    }
    
    /**
    * delayDuration
    * @dev function that delays ICO during days
    **/
    function delay_Duration(uint256 _delayDays) public onlyOwner {
        require(!endStatus && block.timestamp <= START.add(PERIOD.mul(1 days)), "can't delay duration");
        PERIOD = PERIOD.add(_delayDays);
    }

    function setStartTime(uint256 _startTime) public onlyOwner {
        START = _startTime;
    }

    /**
     * @dev function that sets price rate (avax : CC)
     */
    function setPriceRate(uint rate) external onlyOwner {
        tokenchangeRate = rate.div(1000);
    }
    
    function setCCoinTokenAddress(address _CCoinToken) external onlyOwner {
        require (_CCoinToken != address(0x00), "Already CCoinToken address is set.");
        token = IERC20(_CCoinToken);
    }
    /**
    * isActive
    * @dev Determins if the contract is still active
    **/
    function isActive() public view returns (bool) {
        return (
            endStatus == false && 
            block.timestamp >= START && // Must be after the START date
            block.timestamp <= START.add(PERIOD.mul(1 days)) // Must be before the end date
        );
    }

    /**
    * set_EndStatus
    * @dev function that sets ending status
    **/
    function set_EndStatus(bool status) public onlyOwner {
        endStatus = status;
    }

    // withdraw native token
    function withdraw(address to) external onlyOwner {
        payable(to).transfer(address(this).balance);
    }

    // end sale
    function endsale() public onlyOwner {
        // transfer all the remaining tokens to admin
        token.transfer(msg.sender, token.balanceOf(address(this)));
        // transfer all the etherum to admin and self selfdestruct the contract
        selfdestruct(payable(msg.sender));
    }
}