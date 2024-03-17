import os
import json
import inspect
from brownie import *
from dotenv import load_dotenv

load_dotenv()
cCA = os.getenv("cCA")
print("Using cCA: " + cCA)

cultureCoinImplAddress = os.environ['cultureCoinImplAddress']
print("Using CC Impl address of ", cultureCoinImplAddress)

proxyAdmin = os.environ['proxyAdmin']
print("Using proxyAdmin: " + proxyAdmin)

OneCC = 1000000000000000000   # This number is equal to 1 Culture Coin
maxint = 115792089237316195423570985008687907853269984665640564039457584007913129639935
deployAmount = 2 * 210100027 * OneCC

with open('CultureCoin.json') as f:
    ABI = json.load(f)
CC = Contract.from_abi('CultureCoin', cultureCoinImplAddress, ABI)
print(CC)

from scripts.helpful_scripts import encode_function_data
encoded_initializer_function = encode_function_data(CC.initialize, deployAmount, cCA)


def main():
    account = accounts.load("Account1")     # This is the deployer account and is used to deploy the proxy but may not be the cCA
    print("Account1:", account.address)
    print("Balance:", account.balance())
    print("Nonce:", account.nonce)

    # Deploy the contract
    print("Deploying the contract...")

    proxy = TransparentUpgradeableProxy.deploy(
        cultureCoinImplAddress,
        proxyAdmin,
        encoded_initializer_function,
        {"from": account}
    )

    print("Note: Please save new contract address in ../.env: cultureCoinAddress=" + proxy.address)
