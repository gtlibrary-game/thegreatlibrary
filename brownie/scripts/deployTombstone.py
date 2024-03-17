import inspect
from brownie import *
  
def main():
    account = accounts.load("Account1")
    print("Account1:", account.address)
   
    # Deploy the contract
    print("Deploying the contract...")

    tomb = Tombstone.deploy({'from': account}); #, "gas_price": 900000000000})

    print("Note: save new contract address in ../.env: tombstoneImplAddress=" + tomb.address)
