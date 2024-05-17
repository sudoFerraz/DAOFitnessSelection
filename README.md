## Video Explanation

https://www.youtube.com/watch?v=DFz1Y8BRxhk
Unfortunately the microphone level came out very low on editing, please put your volume on max to hear something :)

## Description

RetirementDAO is a project to exemplify the use of the biased roulette selection
algorithm (also known as [Fitness proportionate selection](https://en.wikipedia.org/wiki/Fitness_proportionate_selection)used in genetic algorithms) in the context of a web3 protocol;

It was created for the GlobalDAOHackaton 2021 as a POC to exemplify a new mechanism
for token gated DAOs

The roulette selection is used on the action of picking a random winner that 
would be granted access to the DAO, on this example, we apply it into a context
where the amount of staked tokens of a participant is equivalent to it's level of
fitness;

### Random number generation and normalization

We retrieve the random number from ChainlinkVRF https://docs.chain.link/docs/chainlink-vrf/,
which is then transformed to fit into the subset between 0 and 1. Improving the
normalization of the random number transformation is a hard problem on-chain,
as we can't ensure a uniform distribution when dividing by 10**18 with solidity truncated
divisions.

### Possible applications

A certain participant staked tokens in turn, is equivalent to how many ETH
has been locked from a certain address. Note that a participant cannot withdraw
ETH back or through the form of a SuperToken being streamed constantly to the contract
from a specific address.

When a participant is selected through the biased roulette selection, he earns
the right of minting a new NFT(RetiredNFT), which is the gateway token of RetirementDAO,
who controls the treasury.

The RetirementDAO treasury could then, redistribute all ETH received into a staking pool in aave,
and share all returns from it equally between RetiredNFT holders through a stream like
degen_dogs (https://github.com/markcarey/degendogs) did.

With a fitness function being based on how many certain tokens are staked or that
a person has ownership of, such selection does not include any
incentives for over-time participantion on a DAO or a Protocol, for this reason,
one could consider creating a new ERC20 for issuance within the "staking" action,
which therefore would enable the opportunity of a compound mechanism that would incentivise
time of participation.
After a participant stakes ETH in the protocol, on every new draw round, it's 
weight ('fitness') is compounded by a fixed factor, increasing it's fitness
over-time and incentivizing participation.

##### Token Gated Daos:
  
  Could incentivise the contribution into the DAO, by minting ERC20 tokens to
  contributors that stake such tokens and are counted as an equivalent of fitness
  weights. 

  Contributions by itself could be considered as PRs in a github repo like gitvern
  is doing (https://github.com/gitvern/) or as a ticket bought to a concert or 
  championship or a POAP, also worth to mention that it could be CRED from sourceCred protocol





## Future Contributions to this example

 - Enter pension system
   - [x] Send burneable ERC20 to the auction house to pool tokens
   - [x] Burn tokens sent to be staked
   - [ ] Auction house needs to buy tokens from aave pool
   - [x] Auction house creates a ticket inside the auction house for person who burned the ERC20 
   - [ ] Auction house creates a new draw round every 24 hours
   - [x] Auction house calculates selectedParticipant based on the genetic algorithm and the previous ERC20 sent
   - [x] Auction house mints a new RetiredNFT for selectedParticipant
   - [ ] RetiredNFT owner has the stream from wETH sent to the auction house pooled treasury
   - [ ] Auction house compounds ticket size created on participation



Farm:
- Stake Tokens
- Unstake Tokens
- Issue Tokens
- Add Allowed Tokens
- Get ETH Value.
