import os
import json
import inspect
from brownie import *

from dotenv import load_dotenv
load_dotenv()

cultureCoinAddress = os.environ['cultureCoinAddress']
print("cuturecoin: " + cultureCoinAddress)

def main():
    account = accounts.load("Account1")
    print("Account1:", account.address)
    print("Balance:", account.balance())
    print("Nonce:", account.nonce)

    # Deploy the contract
    print("Deploying the contract...")

    #market = MarketPlace[len(MarketPlace) - 1]

    market = AuctionHouse.deploy(account.address, account.address, cultureCoinAddress, {'from': account}) # , "gas_price": gasPrice})
    print("AuctionHouse deployed at:" + market.address)

    print("Run: brownie run scripts/setupDracula.py")
    #CC.setAddon(auctionHouseAddress, True,  {"from": account})

