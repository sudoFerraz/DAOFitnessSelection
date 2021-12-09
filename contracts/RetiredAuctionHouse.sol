// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@chainlinkOld/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol';
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {
	PausableUpgradeable
} from '@openzeppelinUpgrades/contracts/security/PausableUpgradeable.sol';
import { 
	ReentrancyGuardUpgradeable 
} from '@openzeppelinUpgrades/contracts/security/ReentrancyGuardUpgradeable.sol';
import {
	OwnableUpgradeable
} from '@openzeppelinUpgrades/contracts/access/OwnableUpgradeable.sol';
import {
	RetiredNFT
} from './RetiredNFT.sol';
import {
	TiredToken
} from './TiredToken.sol';
import {
	IRetiredAuctionHouse
} from '../interfaces/IRetiredAuctionHouse.sol';

contract RetiredAuctionHouse is
PausableUpgradeable,
ReentrancyGuardUpgradeable,
OwnableUpgradeable,
IRetiredAuctionHouse {

	// The RetiredNFT ERC721 token contract
	RetiredNFT public retiredNfts;
	// The address of the WETH contract
	address public weth;
	// The minimum amount of time left in an auction after a new ticket is created
	uint256 public timeBuffer;
	// The minimum ticket entrance size accepted in an auction
	uint256 public reservePrice;
	// The duration of a single draw round
	uint256 public duration;
	// The active draw round
	IRetiredAuctionHouse.DrawRound public drawRound;
	enum ROUND_STATE {
		OPEN,
		CLOSED,
		CALCULATING_SELECTED
	}
	ROUND_STATE public roundState;
	TiredToken private tiredToken;
	uint256 public fee;
	bytes32 public keyHash;
	event RequestRandomness(bytes32 requestId);
	address payable[] public participants;
	event NewParticipant(address participant, uint256 amountPooled);

	
	

	function initialize(
		RetiredNFT _retiredNfts,
		address _weth,
		uint256 _timeBuffer,
		uint256 _reservePrice,
		uint256 _duration,
		address _vrfCoordinator,
		address _link,
		uint256 _fee,
		bytes32 _keyHash,
		TiredToken _token
	) external initializer {
		__Pausable_init();
		__ReentrancyGuard_init();
		__Ownable_init();
		_pause();

		tiredToken = _token;
		retiredNfts = _retiredNfts;
		weth = _weth;
		timeBuffer = _timeBuffer;
		reservePrice = _reservePrice;
		duration = _duration;
//		vrfCoordinator = _vrfCoordinator;
		fee = _fee;
		keyHash = _keyHash;
	}

	// Settle the current round and mint a new nft for next draw
	function settleCurrentAndCreateNewDrawRound() external nonReentrant whenNotPaused {
	//	_settleDrawRound();
		//_createAuction();
	}

	// Settle the current auction
	function settleDrawRound() external whenPaused nonReentrant {
		_settleDrawRound();
	}

	function createNewTicket(uint256 retiredNftId) external payable nonReentrant {
		IRetiredAuctionHouse.DrawRound memory _drawRound = drawRound;

		require(_drawRound.retiredNftId == retiredNftId, 'Nft is not being drawn');
	}

	function _settleDrawRound() internal {
		IRetiredAuctionHouse.DrawRound memory _drawRound = drawRound;

		require(_drawRound.startTime != 0, 'Draw Round hasnt begun');
		require(!_drawRound.settled, 'Draw Round has already been settled');
		require(block.timestamp >= _drawRound.endTime, 'Draw Round hasnt completed');

		drawRound.settled = true;

		retiredNfts.createRetiredNFT(_drawRound.selectedParticipant);

		emit DrawRoundSettled(_drawRound.selectedParticipant);

	}

	function enterPension() public payable {
		require(roundState == ROUND_STATE.OPEN);
		require(msg.value >= 0, "Haven't pooled TIRED!");
		participants.push(payable(msg.sender));
		emit NewParticipant(msg.sender, msg.value);
	}

	function getEntranceFee() public {}

	function burnTiredTokens(uint256 amount) external {
		address from = msg.sender;
		tiredToken.burnFrom(from, amount);
	}

	function transferERC20(IERC20 token, address to, uint256 amount) public {

	}

	function _poolNewTokens() external payable nonReentrant {


	}

	function _createDrawRound() internal {
		uint256 startTime = block.timestamp;
		uint256 endTime = startTime + duration;

		drawRound = DrawRound({
			retiredNftId: retiredNfts.tokenCounter(),
			ticketSize: 0,
			startTime: startTime,
			endTime: endTime,
			selectedParticipant: payable(0),
			settled: false
		});

		emit DrawRoundCreated(retiredNfts.tokenCounter(), startTime, endTime);
	}


}
