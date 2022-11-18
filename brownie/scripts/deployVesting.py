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

    print("WARNING!!! YOU MAY HAVE TO REDEPLOY THE CLOUD CODE AT THE END OF THE DEPLOYMENT PROCESS: bakerydemo% bash deployCloud.sh")
