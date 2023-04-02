import os
import time
import inspect
from brownie import *
from datetime import datetime
from dotenv import load_dotenv

load_dotenv()
cCA = os.getenv("cCA")
print("Using cCA: " + cCA)
cultureCoinAddress = os.environ['cultureCoinAddress']
print("Using CC address of ", cultureCoinAddress)
tokenPreSale = os.environ['tokenPreSale']
print("Using tokenPreSale:", tokenPreSale)
vestingContract = os.environ['vestingContract']
print("Using vestingContract:", vestingContract)


def main():
    # Load the account using the private key from the environment
    #operator_account = accounts.add(os.getenv("OPERATOR_PRIVATE_KEY"))
    account = accounts.load("Account1")

    # Load the token presale contract using the address from the environment
    myTokenPreSale = Contract(tokenPreSale)

    # Set the vesting contract address
    tx = myTokenPreSale.setVestingContractAddress(vestingContract, {"from": account})

    # Confirm the transaction
    tx.wait(1)
    print(f"Vesting contract address set to: {vestingContract}")

    myVesting = Contract(vestingContract)

    tx = myVesting.setVestingAllocation({"from": account})


"""
def main():
    account = accounts.load("Account1")     # This is the deployer account and NOT always the cCA so please use: cCA and not account.address
    print("Account1:", account.address)
    print("Balance:", account.balance())
    print("Nonce:", account.nonce)

    # Deploy the contract
    print("Deploying the contract...")

    #// constructor
    #constructor(address _tokenaddress, uint256 _tokenvalue, uint _startTime, uint _duringDays){
    #tokenprice = _tokenvalue;
    #token  = IERC20(_tokenaddress);
    #START = _startTime;
    #DAYS = _duringDays;
    #}

    Vesting.deploy(cultureCoinAddress,
                                    tokenPreSale,
                                    {'from': account}) # , "gas_price": gasPrice})

"""
