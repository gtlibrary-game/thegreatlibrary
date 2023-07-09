// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../openzeppelin-solidity/contracts/security/ReentrancyGuard.sol";

interface LiveTradables {
	function getSpawn(uint256 _tokenId) external returns(uint256);
	function getNBT() external returns(address);
}
