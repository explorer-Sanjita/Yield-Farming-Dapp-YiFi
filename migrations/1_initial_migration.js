/* smart contracts can have changes & after making changes they need to be redeployed 
& hance the address of this new smart contract needs to be updated 
this file ensures that the whenever we deploy smart contract again after making some 
changes Migrations.sol runs as well
location of migrations.sol needn't be specified 'coz its already present in 
truffle-congig.js  contracts_directory: './src/contracts/' 
*/
// eslint-disable-next-line no-undef
const Migrations = artifacts.require('Migrations');

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
