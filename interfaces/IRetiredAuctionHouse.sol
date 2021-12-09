// SPDX-License-Identifier: MIT

/// @title Interface for the Retired Auction House

pragma solidity ^0.8.0;

interface IRetiredAuctionHouse {
	struct DrawRound {
		// ID of the RetiredNFT (ERC721 token ID)
		uint256 retiredNftId;

		// The current highest size ticket
		uint256 ticketSize;

		// The time that the draw round started
		uint256 startTime;

		// The time that the auction is scheduled to end
		uint256 endTime;

		// The address of the current highest size ticket
		address payable selectedParticipant;

		// Wether or not the draw round has been settled
		bool settled;
	}

	event DrawRoundCreated(
		uint256 indexed retiredNftId,
		uint256 startTime,
		uint256 endTime
	);

//	event CreateNewTicket(
//		uint256 indexed retiredNftId,
//		address sender,
//		uint256 value,
//		bool extended
//	);

//	event DrawRoundExtended(
//		uint256 indexed retiredNftId,
//		uint256 endTime
//	);

	event DrawRoundSettled(
		address selectedParticipant
	);

//	event DrawRoundTimeBufferUpdated(uint256 timeBuffer);

//	event DrawRoundReservePriceUpdated(uint256 reservePrice);

	function settleDrawRound() external;

	function settleCurrentAndCreateNewDrawRound() external;

//	function createNewTicket(uint256 amount) external payable;

//	function pause() external;

//	function unpause() external;

//	function setTimeBuffer(uint256 timeBuffer) external;

//	function setReservePrice(uint256 reservePrice) external;

}
