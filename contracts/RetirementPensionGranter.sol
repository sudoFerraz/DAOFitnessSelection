// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/dev/VRFConsumerBase.sol";
import {
	TiredToken
} from './TiredToken.sol';
import "@openzeppelin/contracts/access/Ownable.sol";


contract RetirementPensionGranter is VRFConsumerBase, Ownable {

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
	enum ROUND_STATE {
		OPEN,
		CLOSED,
		CALCULATING_WINNER
	}
	ROUND_STATE public roundState;
	event RequestRandomness(bytes32 requestId);

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

	function startRound() public onlyOwner {
		require(roundState == ROUND_STATE.CLOSED, "Can't start a new lottery yet");
		roundState = ROUND_STATE.OPEN;
	}

	function endRound() public onlyOwner {
		roundState = ROUND_STATE.CALCULATING_WINNER;
		bytes32 requestId = requestRandomness(keyHash, fee);
		emit RequestRandomness(requestId);
	}

	function burnTiredTokens(uint256 _amount) external {
		require(_amount > 0);
		address from = msg.sender;
		tiredToken.burnFrom(from, _amount);
		addUserToParticipants(from, _amount);
		emit UserBurnedTokens(from, _amount);
	}

	function fulfillRandomness(bytes32 _requestId, uint256 _randomNumber) internal override {
		require(roundState == ROUND_STATE.CALCULATING_WINNER, "You aren't there yet!");
		require(_randomNumber > 0, "random not found");

	}

	function calculateSelectedParticipant() public view returns(address) {

	}


}
