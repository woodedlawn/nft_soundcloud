import os
import json

from web3 import Web3
from dotenv import load_dotenv
load_dotenv()   


smart_contract_address = os.getenv("SMART_CONTRACT_ADDRESS")
smart_contract_abi_location = os.getenv("SMART_CONTRACT_ABI")
infura_project_id = os.getenv("INFURA_PROJECT_ID")

w3 = Web3(Web3.HTTPProvider(f"https://rinkeby.infura.io/v3/{infura_project_id}"))

f = open(smart_contract_abi_location)
smart_contract_json = json.load(f)
smart_contract_abi = smart_contract_json['abi']


# Create a function that calls getSounds on the smart contract and returns a list of dsictionaries of sounds
def get_sounds():
  contract_instance = w3.eth.contract(address=smart_contract_address, abi=smart_contract_abi)
  sounds = contract_instance.functions.getSounds().call()
  return sounds
