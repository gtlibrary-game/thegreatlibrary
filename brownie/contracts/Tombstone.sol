// SPDX-License-Identifier:	UNLICENSED

pragma solidity ^0.8.0;

import "./Constants.sol";
import "./Base.sol";
import "./DraculaLoot.sol";
import "./Relics.sol";
import "./DraculaHero.sol";
import "./CultureCoin.sol";

import "../openzeppelin-contracts-upgradeable/contracts/security/ReentrancyGuardUpgradeable.sol";

contract Tombstone is ReentrancyGuardUpgradeable {
	address private cCA;

	DraculaHero private hero;
	DraculaLoot private loot;
	Relics private items;

	mapping(address => bool) public isAddon;

    	function initialize (address _cCA, address _hero, address _loot, address _items) external initializer {

		__ReentrancyGuard_init();

		cCA = _cCA;

		hero = DraculaHero(_hero);
		loot = DraculaLoot(_loot);
		items = Relics(_items);
    	}

	uint LOOT_IDX = 0;	// For ease of reading.
	uint AMOUNT_IDX = 1;
	mapping(uint256 => uint256[12]) private amounts;
	mapping(uint256 => uint256[12]) private lootIds;

	// Call this function on an item id to find out what it's transmute properties are
	function getTransmuteByItem(uint256 _iId) public view returns (uint256[12] memory, uint256[12] memory) {
		return (lootIds[_iId], amounts[_iId]);
    	}

	function transmute1(uint256 _hId, int _slot, uint _time, uint _what, uint _amount) public returns(uint256) {
		require(msg.sender == hero.ownerOf(_hId) || cCA == msg.sender || isAddon[msg.sender], "You don't own that hero.");
		loot.burnFrom(msg.sender, _what, _amount);

		uint256 newItem = items.addonItemMint(address(hero), _hId, msg.sender, _slot);

		uint256[12] memory _amounts;
		uint256[12] memory _lootIds;

		_lootIds[0] = _what;
		_amounts[0] = _amount;

		amounts[newItem] = _amounts;	// the first is very small grid.
		lootIds[newItem] = _lootIds;

		return newItem;
	}
	function transmute2(uint256 _hId, int _slot, uint _time, uint _what, uint _amount, uint _w2, uint _a2) public returns(uint256) {
                require(msg.sender == hero.ownerOf(_hId) || cCA == msg.sender || isAddon[msg.sender], "You don't own that hero.");
                loot.burnFrom(msg.sender, _what, _amount);
                loot.burnFrom(msg.sender, _w2, _a2);

                uint256 newItem = items.addonItemMint(address(hero), _hId, msg.sender, _slot);

                uint256[12] memory _amounts;
                uint256[12] memory _lootIds;

                _lootIds[0] = _what;
                _amounts[0] = _amount;
                _lootIds[1] = _w2;
                _amounts[1] = _a2;

                amounts[newItem] = _amounts;
                lootIds[newItem] = _lootIds;

		return newItem;
        }

function transmute(uint256 _hId, int _slot, uint _time, uint[12] memory _lootIds, uint[12] memory _amounts) public returns(uint256) {
    require(msg.sender == hero.ownerOf(_hId) || cCA == msg.sender || isAddon[msg.sender], "You don't own that hero.");
    for (uint i = 0; i < 12; i++) {
        if (_lootIds[i] != 0  && _amounts[i] != 0) {
            loot.burnFrom(msg.sender, _lootIds[i], _amounts[i]);
        }
    }

    uint256 newItem = items.addonItemMint(address(hero), _hId, msg.sender, _slot);

    amounts[newItem] = _amounts;
    lootIds[newItem] = _lootIds;

    return newItem;
}



	function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4) {
                return 0xf0b9e5ba;
        }
}

