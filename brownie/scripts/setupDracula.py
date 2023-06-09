import os
import json
import inspect
from brownie import *

from dotenv import load_dotenv
load_dotenv()

#gasPrice = 100000000000

draculaLootAddress = os.environ['draculaLootAddress']
relicsAddress = os.environ['relicsAddress']
tombstoneAddress = os.environ['tombstoneAddress']

with open('DraculaLoot.json') as f:
    dlABI = json.load(f)

dracula_loot = Contract.from_abi('DraculaLoot', draculaLootAddress, dlABI)
print(dracula_loot)

with open('Relics.json') as f:
    rABI = json.load(f)

relics = Contract.from_abi('Relics', relicsAddress, dlABI)
print(relics)

def main():
    account = accounts.load("Account1")
    print("Account1:", account.address)
    print("Balance:", account.balance())
    print("Nonce:", account.nonce)

    # Deploy the contract
    print("Setting up the dracula_loot contract addon (Tombstone)...")
    dracula_loot.setAddon(tombstoneAddress, True, {"from": account})

    print("Setting up the relics contract addon (Tombstone)...")
    relics.setAddon(tombstoneAddress, True, {"from": account})


