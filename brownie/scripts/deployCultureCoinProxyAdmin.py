import inspect
from brownie import *

  
def main():
    account = accounts.load("Account1")
    print("Account1:", account.address)

   
    # Deploy the contract
    print("Deploying the Proxy Admin Address for Culture Coin...")

    proxyAdmin = ProxyAdmin.deploy( {"from": account.address})

    print("Note: save new contract address in ../.env: proxyAdmin=" + proxyAdmin.address)
