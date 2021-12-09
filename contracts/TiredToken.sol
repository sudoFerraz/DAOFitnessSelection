// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract TiredToken is ERC20, ERC20Burnable {

	constructor(uint256 initialSupply) ERC20("TiredToken", "TIRED") {
		_mint(msg.sender, initialSupply);
	}
}
