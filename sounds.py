import os
from web3 import Web3
from dotenv import load_dotenv
load_dotenv()   


smart_contract_address = os.getenv("SMART_CONTRACT_ADDRESS")
smart_contract_abi = os.getenv("SMART_CONTRACT_ABI")


# Create a function that calls getSounds on the smart contract and returns a list of dsictionaries of sounds

# Configure w3, e.g., w3 = Web3(...)
address = smart_contract_address
abi = smart_contract_abi
contract_instance = w3.eth.SoundChain(address=address, abi=abi)

# read state:
contract_instance.getSounds.storedValue().call()
# 42

# update state:
tx_hash = contract_instance.getSounds.updateValue(43).transact()