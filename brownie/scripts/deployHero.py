import os
import json
import inspect
from brownie import *

from dotenv import load_dotenv
load_dotenv()

#gasPrice = 100000000000

cCA = os.environ['cCA']
cultureCoinAddress = os.environ['cultureCoinAddress']

bookmarkAddress = os.environ['bookmarkAddress']
baseSpellsAddress = os.environ['baseSpellsAddress']
myItemsAddress = os.environ['myItemsAddress']

# Load the ABI from disk
with open('CultureCoin.json') as f:
    abi = json.load(f)

culture_coin = Contract.from_abi('CultureCoin', cultureCoinAddress, abi)
print(culture_coin)


def main():
    account = accounts.load("Account1")
    print("Account1:", account.address)
    print("Balance:", account.balance())
    print("Nonce:", account.nonce)

    # Deploy the contract
    print("Deploying the contract...")

    # address _cCA, address _cultureCoin, address _nbt, address _registryAddress, address _baseSpells, address _myItems

    registryAddress = "0"
    hero = Hero.deploy(cCA, cultureCoinAddress, bookmarkAddress, bookmarkAddress, baseSpellsAddress, myItemsAddress, {"from": account})

    culture_coin.setAddon(hero.address, True, {"from": account})

    ### , "gas": gasPrice})
