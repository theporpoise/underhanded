var BradenCoin = artifacts.require("./BradenCoin.sol");

module.exports = function(deployer) {
  deployer.deploy(BradenCoin);
};
