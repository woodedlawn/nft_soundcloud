function handleAccountsChanged(accounts) {
  if (accounts && accounts.length > 0) {
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

$(document).ready(function () {
  // check for connected etherium account
  ethereum
    .request({ method: "eth_accounts" })
    .then(handleAccountsChanged)
    .catch((err) => {
      console.error(err);
    });

  // connect an ethereum account
  $("#connect-btn").click(function () {
    connectEth();
  });

  // disable form submissions if there are invalid fields
  // Fetch all the forms we want to apply custom Bootstrap validation styles to
  const forms = document.querySelectorAll(".needs-validation");
  // Loop over them and prevent submission
  Array.prototype.slice.call(forms).forEach(function (form) {
    console.log("adding listener");
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
