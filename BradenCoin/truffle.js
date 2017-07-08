//var HDWalletProvider = require("truffle-hdwallet-provider");

//var mnemonic = "opinion destroy betray ...";

module.exports = {
  networks: {
    live: { // host:localhost//port:8545//gas//gasPrice//from - default address to use for any transaction Truffle makes during migrations
      network_id: 1,
    },
    morden: {
      network_id: 2,
      host: "https://morden.infura.io",
    },
    ropsten: {
      //provider: new HDWalletProvider(mnemonic, "https://ropsten.infura.io"),
      network_id: "3"
    },
    testrpc: {
      network_id: "default"
    },
    development: {
      host: "localhost",
      port: "8545",
      network_id: "default",
      gas: 4712388
    }
  }
};
