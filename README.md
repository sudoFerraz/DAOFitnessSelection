## Description

RetirementDAO is a project to exemplify the use of the biased roulette selection
algorithm (also known as [Fitness proportionate selection](https://en.wikipedia.org/wiki/Fitness_proportionate_selection)used in genetic algorithms) in the context of a web3 protocol;

It was created for the GlobalDAOHackaton 2021

The roulette selection is used on the action of picking a random winner that 
would be granted access to the DAO, using the participants staked tokens as a weight
of fitness;

A certain participant staked tokens in turn, is equivalent to how many ETH
has been locked from a certain address. Note that a participant cannot withdraw
ETH back.

When a participant is selected through the biased roulette selection, he earns
the right of minting a new NFT(RetiredNFT), which is the gateway token of RetirementDAO,
who controls the treasury.

The RetirementDAO treasury, redistributes all ETH received into a staking pool in aave,
and share all returns from it equally between RetiredNFT holders.

After a participant stakes ETH in the protocol, on every new draw round, it's 
weight ('fitness') is compounded by a fixed factor, increasing it's fitness
over-time and incentivizing participation.

## Installation

In order to run the project locally, you'll need to have Docker and docker-compose.


```bash
$ docker-compose build
$ docker-compose up
```

## Test



## Tasks to do

 - Enter pension system
   - Send wETH to the auction house to pool tokens
   - Auction house needs to buy tokens from aave pool
   - Auction house pools the tokens inside the auction house for person who sent the wETH
   - Auction house creates a new draw round every 24 hours
   - Auction house calculates selectedParticipant based on the genetic algorithm and the previous wETH sent
   - Auction house mints a new RetiredNFT for selectedParticipant
   - RetiredNFT owner has the stream from wETH sent to the auction house pooled treasury
   - 
   - 


Compounds on the last amount you wrote to incentivize continuous contributions


Farm:
- Stake Tokens
- Unstake Tokens
- Issue Tokens
- Add Allowed Tokens
- Get ETH Value
