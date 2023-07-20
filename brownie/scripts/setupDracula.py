import os
import json
import inspect
from brownie import *

from dotenv import load_dotenv
load_dotenv()

#gasPrice = 100000000000

draculaLootAddress = os.environ['draculaLootAddress']
relicsAddress = os.environ['relicsAddress']
draculaHeroAddress = os.environ['draculaHeroAddress']
tombstoneAddress = os.environ['tombstoneAddress']
auctionHouseAddress = os.environ['auctionHouseAddress']
cultureCoinAddress = os.environ['cultureCoinAddress']

with open('DraculaLoot.json') as f:
    dlABI = json.load(f)
dracula_loot = Contract.from_abi('DraculaLoot', draculaLootAddress, dlABI)
print(dracula_loot)

with open('Relics.json') as f:
    rABI = json.load(f)
relics = Contract.from_abi('Relics', relicsAddress, dlABI)
print(relics)

with open('CultureCoin.json') as f:
    rABI = json.load(f)
CC = Contract.from_abi('CultureCoin', cultureCoinAddress, dlABI)
print(CC)

with open('DraculaHero.json') as f:
    rABI = json.load(f)
heroes = Contract.from_abi('DraculaHero', draculaHeroAddress, dlABI)
print(heroes)


def main():
    account = accounts.load("Account1")
    print("Account1:", account.address)
    print("Balance:", account.balance())
    print("Nonce:", account.nonce)

    print("CC setAddon (AuctionHouse)")
    CC.setAddon(auctionHouseAddress, True,  {"from": account})

    # Deploy the contract
    print("Setting up the dracula_loot contract addon (Tombstone)...")
    dracula_loot.setAddon(tombstoneAddress, True, {"from": account})

    print("Setting up the relics contract addon (Tombstone)...")
    relics.setAddon(tombstoneAddress, True, {"from": account})

    # Need the auction house as an addon too.
    print("Setting up the relics contract addon (AutionHouse)...")
    relics.setAddon(auctionHouseAddress, True, {"from": account})
    
    # Need the auction house as an addon too.
    print("Setting up the heroes contract addon (AutionHouse)...")
    heroes.setAddon(auctionHouseAddress, True, {"from": account})


