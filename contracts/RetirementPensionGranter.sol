// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/dev/VRFConsumerBase.sol";
import {
	TiredToken
} from './TiredToken.sol';


contract RetirementPensionGranter is VRFConsumerBase {

	struct Ticket{
		bool valid;
		uint256 ticketSize;
	}

	bytes32 public keyHash;
	uint256 public fee;
	TiredToken public tiredToken;
	address[] participants;
	mapping(address => Ticket) public participantToAmount;
	event UserBurnedTokens(address burnerUser, uint256 burnedAmount);

	constructor(
		address _VRFCoordinator,
		address _linkToken,
		TiredToken _tiredToken,
		bytes32 _keyHash,
		uint256 _fee
	) public
	VRFConsumerBase(_VRFCoordinator, _linkToken)
	{
		keyHash = _keyHash;
		fee = _fee;
		tiredToken = _tiredToken;
	}

	function addUserToParticipants(address _user, uint256 _burnedAmount) internal {
		require(_burnedAmount > 0);
		require(!participantToAmount[_user].valid);
		participants.push(payable(msg.sender));
		participantToAmount[_user] = Ticket(true, _burnedAmount);
	}

	function burnTiredTokens(uint256 _amount) external {
		require(_amount > 0);
		address from = msg.sender;
		tiredToken.burnFrom(from, _amount);
		addUserToParticipants(from, _amount);
		emit UserBurnedTokens(from, _amount);
	}

	function fulfillRandomness(bytes32 requestId, uint256 randomNumber) internal override {

	}


}
