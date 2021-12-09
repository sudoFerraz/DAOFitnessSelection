from scripts.helpful_scripts import (
    get_account,
    get_contract,
    fund_with_link,
)
from brownie import TiredToken, RetiredNFT, config, network, RetirementPensionGranter
from web3 import Web3

initialSupply = Web3.toWei(1000, "ether")

def getActiveNetwork():
    return network.show_active()

def getFromAccountObject(account):
    return {"from": account}

def deployAndCreate():
    account = get_account()
    print(account)
    retiredNft  = RetiredNFT.deploy(
        get_contract("vrf_coordinator"),
        get_contract("link_token"),
        config["networks"][getActiveNetwork()]["keyhash"],
        config["networks"][getActiveNetwork()]["fee"],
        {"from": account},
    )
    print("We deployed the retiredNFTContract")
    print(retiredNft)
    fund_with_link(retiredNft.address)
    print("We funded the nft contract with link")
    createdTransaction = retiredNft.createRetiredNFT(account.address)
    print("Creating a new retiredNft")
    createdTransaction.wait(1)
    print("New retiredNft has been created")
    return retiredNft, createdTransaction

def deployTiredToken():
    account = get_account()
    print("Creating a new tired token")
    tiredToken = TiredToken.deploy(
        initialSupply,
        {"from": account}
    )
    print("The TiredToken was deployed")
    deployedSupply = tiredToken.balanceOf(account.address)
    print(deployedSupply)
    return tiredToken

def deployPensionGranter():
    account = get_account()
    print(account)
    retirementPensionGranter = RetirementPensionGranter.deploy(
        get_contract("vrf_coordinator"),
        get_contract("link_token"),
        get_contract("tiredToken"),
        config["networks"][getActiveNetwork()]["keyhash"],
        config["networks"][getActiveNetwork()]["fee"],
        getFromAccountObject(account)
    )
    print("Deployed PensionGranter")
    fund_with_link(retirementPensionGranter.address)
    return retirementPensionGranter


def main():
    deployAndCreate()
    tiredToken = deployTiredToken()
    retirementPensionGranter = deployPensionGranter()
    print('\n')
    print("[+] Deployed all contracts now")
    print(retirementPensionGranter)
    account = get_account()
    transferTransaction = tiredToken.transfer(get_account(index=2), 2000)
    transferTransaction.wait(1)
    approveTransaction = tiredToken.approve(retirementPensionGranter.address, 100000000000)
    approveTransaction.wait(1)
    burnTransaction = retirementPensionGranter.burnTiredTokens(2000)
    burnTransaction.wait(1)
    deployedSupply = tiredToken.balanceOf(account.address)
    print(deployedSupply)
#    retirementPensionGranter.burnTiredTokens(Web3.toWei(183, "ether"), {"from": account})
