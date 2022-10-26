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
cCICOPrice = os.environ['cCICOPrice']
print("Using CC Price:", cCICOPrice)
iCOStart = os.environ['iCOStart']
print("using iCOStart:", iCOStart)
iCODays = os.environ['iCODays']
print("using iCODays:", iCODays)

iCOStart = eval(iCOStart)
print("iCOStart:", iCOStart)

epoch_time = datetime(1970, 1, 1)
delta = (iCOStart - epoch_time)
print('Datetime to Seconds since epoch:', delta.total_seconds())
iCOStart = str(int(delta.total_seconds()))
print("Timestamp for start of ico:", iCOStart)

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

    TokenPreSale.deploy(cultureCoinAddress,
                                    cCICOPrice, 
				    iCOStart, iCODays, 
                                    {'from': account}) # , "gas_price": gasPrice})

    print("WARNING!!! YOU MAY HAVE TO REDEPLOY THE CLOUD CODE AT THE END OF THE DEPLOYMENT PROCESS: bakerydemo% bash deployCloud.sh")
