import os
import inspect
from brownie import *

from dotenv import load_dotenv
load_dotenv()

cCA = os.environ['draculaCCA']
cultureCoinAddress = os.environ['cultureCoinAddress']
bookmarkAddress = os.environ['draculaBookmarkAddress']

def main():
    account = accounts.load("Account1")
    print("Account1:", account.address)
    print("Balance:", account.balance())
    print("Nonce:", account.nonce)

    # Deploy the contract
    print("Deploying the contract...")

    relics = Relics.deploy(cCA, cultureCoinAddress, bookmarkAddress, bookmarkAddress, {"from": account})

    print("Note: save new contract address in ../.env: relicsAddress=" + relics.address)

