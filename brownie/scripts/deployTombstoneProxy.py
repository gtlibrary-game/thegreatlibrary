import os
import inspect
from brownie import *
from dotenv import load_dotenv

load_dotenv()
cCA = os.getenv("draculaCCA")
print("Using dracula's cCA: " + cCA)

tombstoneImplAddress = os.environ['tombstoneImplAddress']
print("Using Tombstone Impl address of ", tombstoneImplAddress)
cultureCoinAddress = os.environ['cultureCoinAddress']
print("Using CultureCoin address of ", cultureCoinAddress)

draculaLootAddress = os.environ['draculaLootAddress']
print("Using DraculaLoot address of ", draculaLootAddress)
relicsAddress = os.environ['relicsAddress']
print("Using Relics address of ", relicsAddress)
draculaHeroAddress = os.environ['draculaHeroAddress']
print("Using Hero address of ", draculaHeroAddress)

proxyAdmin = os.environ['proxyAdmin']
print("Using proxyAdmin: " + proxyAdmin)

from scripts.helpful_scripts import encode_function_data

# address _cCA, address _cultureCoin, address _hero, address _spells, address _loot, address _items, string memory _uri
encoded_initializer_function = encode_function_data(Tombstone[-1].initialize, cCA, draculaHeroAddress, draculaLootAddress, relicsAddress)


def main():
    account = accounts.load("Account1")     # This is the deployer account and is used to deploy the proxy but may not be the cCA
    print("Account1:", account.address)
    print("Balance:", account.balance())
    print("Nonce:", account.nonce)

    # Deploy the contract
    print("Deploying the contract...")

    proxy = TransparentUpgradeableProxy.deploy(
        tombstoneImplAddress,
        proxyAdmin,
        encoded_initializer_function,
        {"from": account}
    )

