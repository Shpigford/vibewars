const { ethers } = window.ethers;
// TODO: move url to env variable?
const provider = new ethers.providers.JsonRpcProvider('https://eth-mainnet.alchemyapi.io/v2/zBgPnDapcSyQNLvJE3xN2wv65Nnhvayk');

const getCache = () => {
  try {
    return JSON.parse(localStorage.getItem('ensNames')) || {};
  }
  catch (e) {
    return {};
  }
}

export const ensNameOrAddress = async (address) => {
  // Regardless of current cached value, we'll still do the look up to refesh the cache
  const ensNamePromise = provider.lookupAddress(address).then((ensName) => {
    const cache = getCache();
    cache[address] = ensName || undefined;
    localStorage.setItem('ensNames', JSON.stringify(cache));
    return ensName || address;
  });

  // Return cached value if we have it, otherwise wait for lookup
  const cache = getCache();
  return cache[address] || await ensNamePromise;
}
