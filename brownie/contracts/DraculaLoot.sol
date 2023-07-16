// SPDX-License-Identifier:        UNLICENSED

pragma solidity ^0.8.0;

import "./Constants.sol";
import "./Base.sol";
import "./DraculaHero.sol";
import "./CultureCoin.sol";

contract DraculaLoot is Base {

        address private cCA;
	mapping(uint256 => mapping(uint256 => bool)) private isLooted;
	mapping(address => bool) public isAddon;
	uint256 private _unused;

	CultureCoin CC;
	uint256 lootCost;

        function initialize (address _cCA, address _cultureCoin, uint256 _lootCost,  string memory _uri) external initializer {
                __ERC1155_init(_uri);
                __ERC1155Burnable_init();
                __ReentrancyGuard_init();

		CC = CultureCoin(_cultureCoin);

                cCA = _cCA;

		lootCost = _lootCost;
        }
	function getAddon(address _addon) external view returns(bool) {
        	return isAddon[_addon];
    	}
	function setAddon(address _addon, bool _onOff) public {
                require(msg.sender == cCA, "Only admins may set addon.");
                isAddon[_addon] = _onOff;
        }
	function burnFrom(address _sender, uint _what, uint _amount) public {
		require(cCA == msg.sender || isAddon[msg.sender], "burnFrom");
		_burn(_sender, _what, _amount);
	}
	function mintLoot(address _hero, uint256 _hId, uint256 _lootId, uint256 _amount, uint256 _bmRoyalty, uint256 _ownerRoyalty) public {
		require(msg.sender == cCA || isAddon[msg.sender], "You can't send loot.");
 		DraculaHero hero = DraculaHero(_hero);
		address hero_owner = hero.ownerOf(_hId);
		uint256 hero_bookmark_id = hero.getSpawn(_hId);
		BookTradable bookmark = BookTradable(hero.getNBT());
		address bookmark_owner = bookmark.ownerOf(hero_bookmark_id);
		address book_owner = bookmark.owner();

		_mint(hero_owner, _lootId, _amount, "hero amount");		// Player gets the loot...
		_mint(bookmark_owner, _lootId, _bmRoyalty, "Bookmark token owner amount");
		_mint(book_owner, _lootId, _ownerRoyalty, "Bookmark contract owner amount");
	} 
	function setLootCost(address _hero, uint256 _lootCost) public {
		require(msg.sender == cCA || isAddon[msg.sender], "You can't set loot cost.");
		lootCost = _lootCost;
	}
	function getLootCost() public view returns(uint) {
		return lootCost;
	}
        function mintLootCC(address _hero, uint256 _hId, uint256 _lootId, uint256 _amount, uint256 _bmRoyalty, uint256 _ownerRoyalty) public {
                require(msg.sender == cCA || isAddon[msg.sender], "You can't send loot.");
                DraculaHero hero = DraculaHero(_hero);
                address hero_owner = hero.ownerOf(_hId);
                uint256 hero_bookmark_id = hero.getSpawn(_hId);
                BookTradable bookmark = BookTradable(hero.getNBT());
                address bookmark_owner = bookmark.ownerOf(hero_bookmark_id);
                address book_owner = bookmark.owner();

		if(lootCost > 0) {	// We are charging a little but to play the game this way. 
			uint256 xAmount = CC.dexCCInFrom(hero_owner, lootCost);
			payable(cCA).transfer(xAmount);
		}

                _mint(hero_owner, _lootId, _amount, "hero amount");             // Player gets the loot...
                _mint(bookmark_owner, _lootId, _bmRoyalty, "Bookmark token owner amount");
                _mint(book_owner, _lootId, _ownerRoyalty, "Bookmark contract owner amount");
        }

}

