import os

from dotenv import load_dotenv
load_dotenv()


smart_contract_address = os.getenv("SMART_CONTRACT_ADDRESS")
smart_contract_abi = os.getenv("SMART_CONTRACT_ABI")


# TODO: Create a function that calls getSounds on the smart contract and returns a list of dsictionaries of sounds