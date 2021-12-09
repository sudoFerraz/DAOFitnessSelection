//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.8/dev/VRFConsumerBase.sol";

contract RetiredNFT is ERC721, VRFConsumerBase {

	uint256 public tokenCounter;
	bytes32 public keyHash;
	uint256 public fee;
	enum TicketCategory{Retired, Contributor}
	mapping(uint256 => TicketCategory) public tokenIdToCategory;
	mapping(bytes32 => address) public requestIdToSender;
	event requestedRetiredNFT(bytes32 indexed requestId, address requester);
	event categoryAssigned(uint256 indexed tokenId, TicketCategory category);

	constructor(
		address _VRFCoordinator,
		address _linkToken,
		bytes32 _keyHash,
		uint256 _fee
	) public
	VRFConsumerBase(_VRFCoordinator, _linkToken)
	ERC721("RetiredNFT", "TIRED")
	{
		tokenCounter = 0;
		keyHash = _keyHash;
		fee = _fee;

	}

	function createRetiredNFT(address selectedParticipant) public returns(bytes32) {
		bytes32 requestId = requestRandomness(keyHash, fee);
		requestIdToSender[requestId] = selectedParticipant;
		emit requestedRetiredNFT(requestId, selectedParticipant);
	}

	function fulfillRandomness(bytes32 requestId, uint256 randomNumber) internal override {
		TicketCategory category = TicketCategory(randomNumber % 2);
		uint256 newTokenId = tokenCounter;
		tokenIdToCategory[newTokenId] = category;
		// emit breedAssigned(newTokenId, breed);
		emit categoryAssigned(newTokenId, category);
		address owner = requestIdToSender[requestId];
		_safeMint(owner, newTokenId);
		tokenCounter = tokenCounter + 1;
	}

}
