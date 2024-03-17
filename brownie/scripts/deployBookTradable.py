import os
from brownie import BookTradable, accounts, config
from dotenv import load_dotenv

load_dotenv()
cultureCoinAddress = os.environ['cultureCoinAddress']

def deploy_book_tradable():
    # Load the deployer account
    deployer_account = accounts.load("Account1") 
    # For local development, you might use accounts[0] instead

    # Define the constructor arguments for BookTradable contract
    _name = "BookTradableToken"
    _symbol = "BTT"
    _bookRegistryAddress = deployer_account.address
    _baseuri = "https://booktradabletokens.com/token/"
    _burnable = True
    _maxmint = 5000  # Maximum mintable tokens
    _defaultprice = 0.05e18  # 0.05 ether, adjust as needed
    _defaultfrom = 0  # Default starting index for minting
    _gasToken = cultureCoinAddress  # Address of the gas token
    _cCA = deployer_account.address  # Assuming the deployer is the admin/cCA

    # Deploy the BookTradable contract
    book_tradable_contract = BookTradable.deploy(
        _name,
        _symbol,
        _bookRegistryAddress,
        _baseuri,
        _burnable,
        _maxmint,
        _defaultprice,
        _defaultfrom,
        _gasToken,
        _cCA,
        {"from": deployer_account},
    )

    print(f"BookTradable contract deployed to: {book_tradable_contract.address}")
    print("Be sure to save the address in draculaBookmarkAddress or equivalent: draculaBookmarkAddress=" + book_tradable_contract.address)

def main():
    deploy_book_tradable()
