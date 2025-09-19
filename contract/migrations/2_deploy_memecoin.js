const Memecoin = artifacts.require("Memecoin");

module.exports = function (deployer) {
  deployer.deploy(Memecoin);
};