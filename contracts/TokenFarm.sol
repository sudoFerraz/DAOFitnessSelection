// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenFarm is Ownable {
	
	mapping(address => mapping(address => uint256)) public stakingBalance;
	mapping(address => uint256) public uniqueTokensStaked;
	address[] public allowedTokens;
	address[] public stakers;


	function stakeTokens(uint256 _amount, address _token) public {
		// what tokens can they stake?
		// how much can they stake?
		require(_amount > 0, "Amount must be more than 0");
		require(tokenIsAllowed(_token), "Token is not allowed");
		updateUniqueTokensStaked(msg.sender, _token);
		stakingBalance[_token][msg.sender] = stakingBalance[_token][msg.sender] + _amount;
		if (uniqueTokensStaked[msg.sender] == 1){
			stakers.push(msg.sender);
		}
	}

	function updateUniqueTokensStaked(address _user, address _token) internal {
		if (stakingBalance[_token][_user] <= 0) {
			uniqueTokensStaked[_user] = uniqueTokensStaked[_user] + 1;
		}
	}

	function addAllowedTokens(address _token) public onlyOwner {
		allowedTokens.push(_token);
	}

	function tokenIsAllowed(address _token) public returns (bool) {
		for (
			uint256 allowedTokensIndex=0;
			allowedTokensIndex < allowedTokens.length;
			allowedTokensIndex++
		) {
				if (allowedTokens[allowedTokensIndex] == _token) {
					return true;
				}
				return false;
		}
	}

	function issueTokens() public onlyOwner {
		for (
			uint256 stakersIndex = 0;
			stakersIndex < stakers.length;
			stakersIndex++
		) {
				address recipient = stakers[stakersIndex];
			}

	}

}
