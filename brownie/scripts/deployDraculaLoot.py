import inspect
from brownie import *
  
def main():
    account = accounts.load("Account1")
    print("Account1:", account.address)

   
    # Deploy the contract
    print("Deploying the contract...")

    loot = DraculaLoot.deploy({'from': account});

    culture_coin.setAddon(loot.address, True, {"from": account})
