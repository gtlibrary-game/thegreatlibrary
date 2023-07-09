// SPDX-License-Identifier:	UNLICENSED

pragma solidity ^0.8.0;

import "./Constants.sol";
import "./CultureCoin.sol";
import "./BookTradable.sol";
import "./LiveTradables.sol";
import "./send_receive.sol";

contract DraculaHero is BookTradable, Receiver, LiveTradables {
	mapping(uint256 => uint256) private hSpawn;	// The spawn point is the NBT id for the hero id.
	CultureCoin CC;
	BookTradable private NBT;

	uint256 private basePrice;
	mapping(uint256 => uint256) private mintPrice;

    	constructor (address _cCA, address _cultureCoin, address _nbt, address _registryAddress)
		BookTradable("DraculaHeroes", "DRAC", _registryAddress,
			"https://greatlibrary.io/games/DRAC/heros/", true, MAXUINT, MAXUINT, MAXUINT, _cultureCoin, _cCA) {
		CC = CultureCoin(_cultureCoin);

		NBT = BookTradable(_nbt);

		basePrice = 0;
	}	
	function getNBT() public view returns(address) {
		return address(NBT);
	}
	function getSpawn(uint256 _hId) public view returns(uint256) {
		return hSpawn[_hId];
	}
	function setPrice(uint256 _tokenId, uint256 _price) public {
		require(msg.sender == NBT.ownerOf(_tokenId));
		mintPrice[_tokenId] = _price;
	}
	function getPrice(uint256 _tokenId) public view returns(uint) {
		return basePrice + mintPrice[_tokenId];
	}
	function heroMint(uint256 _tokenId, address _to, int _class, uint256 _amount) public returns(uint256) {
		uint256 _cost = getPrice(_tokenId);
		require(_amount >= _cost, "Costs more.");

		uint256 xAmount = CC.dexCCInFrom(msg.sender, _amount);
		uint256 msgValue = CC.dexXMTSPIn{value:xAmount}();

		CC.approve(address(this), msgValue);						// Do it in one big approval step.

		uint256 halfValue = msgValue / 2;                                             	// Divy up the spoils...
		CC.transferFrom(address(this), NBT.ownerOf(_tokenId), halfValue);

                uint256 otherHalf = msgValue - halfValue;
                uint256 quarterValue = otherHalf / 2;                                           // Authors and admins gets otherhalf the tax.
                uint256 otherQuarter = otherHalf - quarterValue;

		CC.transferFrom(address(this), NBT.owner(), quarterValue);

		CC.burn(otherQuarter);

		uint256 newTokenId = _getNextTokenId();
        	_mint(_to, newTokenId);
        	_incrementTokenId();

		hSpawn[newTokenId] = _tokenId;
		return newTokenId;
	}
}

