const ConvertLib = artifacts.require("ConvertLib");
const MetaCoin = artifacts.require("MetaCoin");
const Omnium = artifacts.require("Omnium");
const AltheraAvatarNft = artifacts.require("AltheraAvatarNFT")

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(MetaCoin);
  deployer.deploy(Omnium);
  deployer.deploy(AltheraAvatarNft);
};
