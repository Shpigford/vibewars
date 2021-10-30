// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"


"use strict";


// Unpkg imports
const Web3Modal = window.Web3Modal.default;
const evmChains = window.evmChains;

// Web3modal instance
let web3Modal

// Chosen wallet provider given by the dialog window
let provider;


// Address of the selected account
let selectedAccount;


/**
 * Setup the orchestra
 */
function init() {
  // Check that the web page is run in a secure context,
  // as otherwise MetaMask won't be available
  if (location.protocol !== 'https:') {
    return;
  }

  // Tell Web3modal what providers we have available.
  // Built-in web browser provider (only one can exist as a time)
  // like MetaMask, Brave or Opera is added automatically by Web3modal
  const providerOptions = {};

  web3Modal = new Web3Modal({
    cacheProvider: true, // optional
    providerOptions, // required
    disableInjectedProvider: false, // optional. For MetaMask / Brave / Opera.
  });
}


/**
 * Kick in the UI action after Web3modal dialog has chosen a provider
 */
async function fetchAccountData() {

  // Get a Web3 instance for the wallet
  const web3 = new Web3(provider);

  //console.log("Web3 instance is", web3);

  // Get connected chain id from Ethereum node
  const chainId = await web3.eth.getChainId();
  // Load chain information over an HTTP API
  const chainData = evmChains.getChain(chainId);
  //document.querySelector("#network-name").textContent = chainData.name;

  // Get list of accounts of the connected wallet
  const accounts = await web3.eth.getAccounts();

  // MetaMask does not give you all accounts, only the selected account
  //console.log("Got accounts", accounts);
  selectedAccount = accounts[0];

  if (getCookie('wallet') == null) {
    var redirect = true;
  }

  setCookie("wallet", selectedAccount, 365);

  if (redirect == true) {
    window.location.href = "/";
  }
}



/**
 * Fetch account data for UI when
 * - User switches accounts in wallet
 * - User switches networks in wallet
 * - User connects wallet initially
 */
async function refreshAccountData() {
  await fetchAccountData(provider);
}

/**
 * Connect wallet button pressed.
 */
async function onConnect() {

  //console.log("Opening a dialog", web3Modal);
  try {
    provider = await web3Modal.connect();
  } catch (e) {
    console.log("Could not get a wallet connection", e);
    return;
  }

  // Subscribe to accounts change
  provider.on("accountsChanged", (accounts) => {
    fetchAccountData();
  });

  // Subscribe to chainId change
  provider.on("chainChanged", (chainId) => {
    fetchAccountData();
  });

  // Subscribe to networkId change
  provider.on("networkChanged", (networkId) => {
    fetchAccountData();
  });

  await refreshAccountData();
}

/**
 * Disconnect wallet button pressed.
 */
async function onDisconnect() {
  if (provider.close) {
    await provider.close();

    // If the cached provider is not cleared,
    // WalletConnect will default to the existing session
    // and does not allow to re-scan the QR code with a new wallet.
    // Depending on your use case you may want or want not his behavior.
    await web3Modal.clearCachedProvider();
    provider = null;
  }

  selectedAccount = null;
  eraseCookie('wallet');
  window.location.href = "/";
}


function setCookie(name, value, days) {
  var expires = "";
  if (days) {
    var date = new Date();
    date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
    expires = "; expires=" + date.toUTCString();
  }
  document.cookie = name + "=" + (value || "") + expires + "; path=/";
}
function getCookie(name) {
  var nameEQ = name + "=";
  var ca = document.cookie.split(';');
  for (var i = 0; i < ca.length; i++) {
    var c = ca[i];
    while (c.charAt(0) == ' ') c = c.substring(1, c.length);
    if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
  }
  return null;
}
function eraseCookie(name) {
  document.cookie = name + '=; Max-Age=-99999999;';
}

window.addEventListener('load', async () => {
  init();

  var selection = document.querySelector("#btn-connect");
  if (selection !== null) {
    selection.addEventListener("click", onConnect);
  } else {
    if (web3Modal.cachedProvider) {
      await onConnect();
    }
  }

  var selection = document.querySelector("#btn-disconnect");
  if (selection !== null) {
    selection.addEventListener("click", onDisconnect);
  }
});