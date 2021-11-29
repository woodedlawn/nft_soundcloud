function handleAccountsChanged(accounts) {
  if (accounts && accounts.length > 0) {
    window.eth_account = accounts[0];
    $("#connect-btn")
      .removeClass("btn-outline-success")
      .addClass("btn-success");
    $("#connect-btn-text").html(accounts[0]);
  } else {
    $("#connect-btn")
      .removeClass("btn-success")
      .addClass("btn-outline-success");
    $("#connect-btn-text").html("Connect MetaMask");
  }
}

function handleNftCreated(txn) {
  if (txn && txn.transactionHash) {
    const {
      transactionHash,
      to: contractAddress,
      events: {
        Transfer: {
          returnValues: { tokenId },
        },
      },
    } = txn;
    const etherscanLink = `https://rinkeby.etherscan.io/tx/${transactionHash}`;
    const openseaLink = `https://testnets.opensea.io/assets/${contractAddress}/${tokenId}`;

    $("#etherscan-link").attr("href", etherscanLink);
    $("#opensea-link").attr("href", openseaLink);
    $("#nft-created").show();
  }
}

window.ethereum.on("accountsChanged", handleAccountsChanged);

async function connectEth() {
  try {
    // Will open the MetaMask UI
    // You should disable this button while the request is pending!
    $("#connect-btn").prop("disabled", true);
    await ethereum.request({ method: "eth_requestAccounts" });
    $("#connect-btn").prop("disabled", false);
  } catch (error) {
    console.error(error);
  }
}

async function loadContract() {
  const web3 = new Web3(window.ethereum);
  const soundChainContractABI = await $.getJSON(
    window.soundChainContractAbiLocation
  );
  const soundChainContract = new web3.eth.Contract(
    soundChainContractABI.abi,
    window.soundChainContractAddress
  );

  return soundChainContract;
}

async function getSounds() {
  const contract = await loadContract();
  const resp = await contract.methods.getSounds().call();
  return resp.map((s) => {
    const { name, instrument, genre, tokenUri } = s;
    return { name, instrument, genre, tokenUri };
  });
}

async function registerSound(tokenUri, name, instrument, genre) {
  const contract = await loadContract();
  const gas = await contract.methods
    .registerSound(eth_account, name, instrument, genre, tokenUri)
    .estimateGas({ from: eth_account });
  const resp = await contract.methods
    .registerSound(eth_account, name, instrument, genre, tokenUri)
    .send({ from: eth_account, gas });
  return resp;
}

$(document).ready(async function () {
  // check for connected ethereum account
  try {
    const accounts = await ethereum.request({ method: "eth_accounts" });
    if (accounts && accounts.length > 0) handleAccountsChanged(accounts);
  } catch (err) {
    console.error(err);
  }

  // connect an ethereum account
  $("#connect-btn").click(function () {
    connectEth();
  });

  // create an NFT
  $("#create-nft").click(async function () {
    const { tokenUri, name, instrument, genre } = window.token_config;
    $(this).prop("disabled", true);
    const txn = await registerSound(tokenUri, name, instrument, genre);
    handleNftCreated(txn);
  });

  // disable form submissions if there are invalid fields
  // Fetch all the forms we want to apply custom Bootstrap validation styles to
  const forms = document.querySelectorAll(".needs-validation");
  // Loop over them and prevent submission
  Array.prototype.slice.call(forms).forEach(function (form) {
    form.addEventListener(
      "submit",
      function (event) {
        if (!form.checkValidity()) {
          event.preventDefault();
          event.stopPropagation();
        }
        form.classList.add("was-validated");
      },
      false
    );
  });
});
