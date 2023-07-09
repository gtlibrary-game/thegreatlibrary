// SPDX-License-Identifier:	UNLICENSED

pragma solidity ^0.8.0;

import "./Constants.sol";
import "./DraculaHero.sol";
import "./Base.sol";
import "./CultureCoin.sol";
import "./BookTradable.sol";
import "./LiveTradables.sol";
import "./send_receive.sol";

import "../openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol";

contract Relics is BookTradable, Receiver, IERC721Receiver, LiveTradables {	// Each game gets differnt items.
	CultureCoin private CC;

	address private nbt;
        mapping(uint256 => uint256) hSpawn;
        mapping(uint256 => int) slot;

	mapping(address => mapping(uint256 => mapping(int => uint256))) private heroSlots;

    	constructor (address _cCA, address _cultureCoin, address _registryAddress, address _nbt)
		BookTradable("Dracula's Relics", "DRACGAME", _registryAddress,
			"https://greatlibrary.io/games/DRACGAME/items/", true, MAXUINT, MAXUINT, MAXUINT, _cultureCoin, _cCA) {
		cCA = _cCA;
		nbt = _nbt;
	}	
	function addonItemMint(address _hero, uint256 _hId, address _to, int _slot) public returns(uint256) {
		require(isAddon[msg.sender] || msg.sender == cCA, "You can't make a new items this way.");

		uint256 newTokenId = _getNextTokenId();
        	_mint(_to, newTokenId);
        	_incrementTokenId();

		hSpawn[newTokenId] = DraculaHero(_hero).getSpawn(_hId);
		slot[newTokenId] = _slot;

		return newTokenId;
	}
	function addonApprove(address _addonAddress, address _sender, uint256 _iId) public {
		require(isAddon[msg.sender] || msg.sender == cCA, "You can't approve like that.");
		_approve(_addonAddress, _iId);
	}

	function getNBT() public view returns(address) {
		return nbt;
	}
	function getSpawn(uint256 _hId) public view returns(uint256) {
                return hSpawn[_hId];
        }

	// This function will also de-equip items.
	function equipItem(address _hero, uint256 _hId, uint256 _iId) public {
		DraculaHero hero = DraculaHero(_hero);
		require(msg.sender == hero.ownerOf(_hId), "You don't own that hero.");
		require(ownerOf(_iId) == msg.sender, "One cannot equip someone else's stuff.");

		if(_iId > 0) {
			_transfer(msg.sender, address(this), _iId);
		}

		uint256 _curItemId = heroSlots[_hero][_hId][slot[_iId]];
		if(_curItemId > 0) {
			_transfer(address(this), msg.sender, _curItemId);
		}
		heroSlots[_hero][_hId][slot[_iId]] = _iId;
	}
	function getItemSlot(uint256 _iId) public view returns(int) {	// What slot the items goes in.
		return slot[_iId];
	}
	function getItemByHeroSlot(address _hero, uint256 _hId, int _slot) public view returns(uint256) {
		return heroSlots[_hero][_hId][_slot];
	}

	function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4) {
        	return 0xf0b9e5ba;
    	}
}
