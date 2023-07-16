import os
import inspect
from brownie import *
from dotenv import load_dotenv

load_dotenv()
cCA = os.getenv("draculaCCA")
print("Using cCA: " + cCA)

cultureCoinAddress = os.environ['cultureCoinAddress']
print("Using cultureCoinAddress: " + cultureCoinAddress)
dlImplAddress = os.environ['draculaLootImplAddress']
print("Using DL Impl address of ", dlImplAddress)
proxyAdmin = os.environ['proxyAdmin']
print("Using proxyAdmin: " + proxyAdmin)

from scripts.helpful_scripts import encode_function_data

## address _cCA, address _cultureCoin, address _baseSpells, string memory _uri # This is .0155 CC which should be around 20 cents.
encoded_initializer_function = encode_function_data(DraculaLoot[-1].initialize, cCA, cultureCoin, 15500000000000000, "https://games.greatlibrary.io/games/DRACULA/DraculaLoot/")

print("Function encoded.")

def main():
    account = accounts.load("Account1")     # This is the deployer account and is used to deploy the proxy but may not be the cCA
    print("Account1:", account.address)
    print("Balance:", account.balance())
    print("Nonce:", account.nonce)

    # Deploy the contract
    print("Deploying the contract...")

    proxy = TransparentUpgradeableProxy.deploy(
        dlImplAddress,
        proxyAdmin,
        encoded_initializer_function,
        {"from": account}
    )
