from brownie import AdvancedCollectible
from scripts.helpful_scripts import fund_with_link, get_account
from web3 import Web3

def main():
    advanced_collectible = AdvancedCollectible[-1]
    tokenCounter = advanced_collectible.tokenCounter()
    print(f"There are now {tokenCounter} collectibles minted!")
    print(advanced_collectible)
