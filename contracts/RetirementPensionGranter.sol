// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/dev/VRFConsumerBase.sol";
import {
	TiredToken
} from './TiredToken.sol';
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {
	RetiredNFT
} from './RetiredNFT.sol';

contract RetirementPensionGranter is VRFConsumerBase, Ownable {

	struct Ticket{
		bool valid;
		uint256 ticketSize;
	}

	RetiredNFT public retiredNft;
	bytes32 public keyHash;
	uint256 public fee;
	TiredToken public tiredToken;
	uint256 totalParticipants;
	address payable public recentWinner;
	mapping (uint => address) participants;
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
		RetiredNFT _retiredNft,
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
		retiredNft = _retiredNft;
	}

	function addUserToParticipants(address _user, uint256 _burnedAmount) internal {
		require(_burnedAmount > 0);
		require(!participantToAmount[_user].valid);
		totalParticipants++;
		participants[totalParticipants] = _user;
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
		address _selectedParticipant = calculateSelectedParticipant(_randomNumber);
		recentWinner = payable(_selectedParticipant);
		retiredNft.createRetiredNFT(_selectedParticipant);
	}

	function calculateSelectedParticipant(uint256 _randomNumber)
	public returns(address) {
		uint256[] memory _arrayOfParticipantFitness = transformParticipantsWeights();
		address selectedParticipant = findParticipantSelected(_randomNumber, _arrayOfParticipantFitness);
		return selectedParticipant;
	}

	function transformParticipantsWeights() public returns (uint256[] memory){
		uint256 _totalStaked = sumParticipantWeights();
		uint256[] memory _normalizedFitness = calculateParticipantFitness(_totalStaked);
		return _normalizedFitness;
	}

	function findParticipantSelected(uint256 _randomNumber, uint256[] memory _normalizedFitness)
	public returns(address) {
		uint256 _normalizedRandom = _randomNumber / (10 ** 18);
		for (
			uint256 _participantIndex = 0;
			_participantIndex < totalParticipants;
			_participantIndex++
		) {
				if (_normalizedFitness[_participantIndex] > _normalizedRandom) {
					if (_normalizedFitness[_participantIndex - 1] <= _normalizedRandom) {
						return participants[_participantIndex];
					}
				}
		}
	}

	function calculateParticipantFitness(uint256 stakedSum) public returns (uint256[] memory) {
		uint256[] memory _normalizedFitness;
		uint256 _currentUserFitness;
		address _currentUser = payable(msg.sender);
		for (
			uint256 _participantIndex = 0;
			_participantIndex < totalParticipants;
			_participantIndex++
		) {
				_currentUser = participants[_participantIndex];
				_currentUserFitness = participantToAmount[_currentUser].ticketSize;
				_normalizedFitness[_participantIndex] = ((_currentUserFitness * 10**18 )/ stakedSum);
				if (_participantIndex != 0) {
					_normalizedFitness[_participantIndex] = _normalizedFitness[_participantIndex] + _normalizedFitness[_participantIndex - 1];
				}
			}
		return _normalizedFitness;
	}

	function sumParticipantWeights() public returns (uint256) {
		uint256 _stakedSum = 0;
		address _currentUser = payable(msg.sender);
		for (
			uint256 _participantIndex = 0;
			_participantIndex < totalParticipants;
			_participantIndex++
		) {
				_currentUser = participants[_participantIndex];
				_stakedSum = _stakedSum + participantToAmount[_currentUser].ticketSize;
			}
			return _stakedSum;
	}


}
