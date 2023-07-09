// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./LiveTradables.sol";
import "./BookTradable.sol";
import "./CultureCoin.sol";
import "./LiveTradables.sol";
import "./send_receive.sol";
import "../openzeppelin-solidity/contracts/security/ReentrancyGuard.sol";

contract AuctionHouse is Receiver, ReentrancyGuard {

    event OnSale(address indexed hostContract, address indexed offerer, uint tokenId, uint price);
    event BalanceWithdrawn (address indexed beneficiary, uint amount);
    event OperatorChanged (address previousOperator, address newOperator);

    address operator;
    uint256 private operatorFee;

    mapping (address => uint) balances;

    mapping(address => mapping(uint256 => uint256)) public price;

    address private cCA;        /// Adminisistrator
    address private gasToken;   /// culturecoin.
    constructor (address _operator, address _cCA, address _gasToken) { // me :: me :: culturecoin
        operator = _operator;
        operatorFee = 1;  // 1% is the default.
        cCA = _cCA;
        gasToken = _gasToken;
    }

    function setFee(uint256 _fee) external {
        require(msg.sender == operator, "Only the operator may change the fee for the marketplace.");

        operatorFee = _fee;
    }

    function getPrice(address _hostContract, uint _tokenId) external view returns(uint) {
	return price[_hostContract][_tokenId];		// If 0 then not for sale.
    }

    function sell(address _hostContract, uint _tokenId, uint _price) external nonReentrant returns(bytes32) {
        BookTradable book = BookTradable(_hostContract);
        address owner = book.ownerOf(_tokenId);
        require(msg.sender == owner, "Caller does not own token");

        price[_hostContract][_tokenId] = _price;

        emit OnSale(_hostContract, owner, _tokenId, _price);
    }

    function buy(address _hostContract, uint _tokenId) external nonReentrant payable {
        LiveTradables live = LiveTradables(_hostContract);
        BookTradable book = BookTradable(_hostContract);
        address owner = book.ownerOf(_tokenId);
        require(price[_hostContract][_tokenId] > 0, "No price set for this token.");
        require(msg.value >= price[_hostContract][_tokenId], "Not enough funds to buy.");

        book.safeTransferFromRegistry(owner, msg.sender, _tokenId);

        price[_hostContract][_tokenId] = 0;

        uint256 ownerFee = book.getRoyalty();

	address bookmark_address = live.getNBT();
	uint256 bookmark_id = live.getSpawn(_tokenId);
	address bookmark_owner = BookTradable(bookmark_address).ownerOf(bookmark_id);

        uint256 operatorCut = (msg.value * operatorFee) / 100;          // Divide to make it a percent.
        uint256 royalties = (msg.value * ownerFee) / 100;               // Divide to make it a percent.
        uint256 royalties2 = (msg.value * ownerFee) / 100;              // Divide to make it a percent.

        uint256 owner_balance = msg.value - royalties - royalties2 - operatorCut;
        balances[operator] += operatorCut;
        balances[book.owner()] += royalties;

	payable(owner).transfer(owner_balance);
	payable(bookmark_owner).transfer(royalties2);

    }

    function buyWithCC(address _hostContract, uint _tokenId, uint256 _amount) external nonReentrant {
        CultureCoin CC = CultureCoin(gasToken);
        LiveTradables live = LiveTradables(_hostContract);
        BookTradable book = BookTradable(_hostContract);
        address owner = book.ownerOf(_tokenId);
        uint256 msgValue = CC.dexCCInFrom(msg.sender, _amount);
        require(msgValue >=  price[_hostContract][_tokenId], "Not enough funds to buy");
        require(price[_hostContract][_tokenId] > 0, "No price set for this token.");

        book.safeTransferFromRegistry(owner, msg.sender, _tokenId);

        uint256 ownerFee = book.getRoyalty();

        address bookmark_address = live.getNBT();
        uint256 bookmark_id = live.getSpawn(_tokenId);
        address bookmark_owner = BookTradable(bookmark_address).ownerOf(bookmark_id);

        uint256 operatorCut = (msgValue * operatorFee) / 100;          // Divide to make it a percent.
        uint256 royalties = (msgValue * ownerFee) / 100;               // Divide to make it a percent.
        uint256 royalties2 = (msgValue * ownerFee) / 100;               // Divide to make it a percent.

        uint256 owner_balance = msgValue - royalties - operatorCut;
        balances[operator] += operatorCut;
        balances[book.owner()] += royalties;

	payable(owner).transfer(owner_balance);
	payable(bookmark_owner).transfer(royalties2);
    }

    function withdrawBalance() external nonReentrant {
        require(balances[msg.sender] > 0,"You don't have any balance to withdraw");
        uint amount = balances[msg.sender];
        payable(msg.sender).transfer(amount);
        balances[msg.sender] = 0;
        emit BalanceWithdrawn(msg.sender, amount);
    }

    function changeOperator(address _newOperator) external nonReentrant {
        require(msg.sender == operator,"only the operator can change the current operator");
        address previousOperator = operator;
        operator = msg.sender;
        emit OperatorChanged(previousOperator, operator);
    }

    function viewBalances(address _address) external view returns (uint) {
        return (balances[_address]);
    }

    function setGasToken(address _gasToken) public {
        require(msg.sender == cCA || msg.sender == operator, "no");
        gasToken = _gasToken; // The new CC's address.
    }
}

