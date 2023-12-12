/*
In the context of Truffle, `artifacts` is an object that provides access to the compiled contract artifacts. Compiled contract artifacts contain information about your Solidity smart contracts, including their ABI (Application Binary Interface), bytecode, and other metadata. These artifacts are generated during the compilation process of your smart contracts and are essential for interacting with them in your DApp.

Here's the meaning of the line of code you provided:

```javascript
const Tether = artifacts.require('Tether');
```

- `artifacts.require('Tether')` is a function call to `artifacts`. It tells Truffle to retrieve the compiled artifact for a contract named 'Tether'. The 'Tether' contract is typically one of your smart contracts that you've defined in your Truffle project.

- `Tether` is a constant variable that holds a reference to the compiled artifact of the 'Tether' contract. This variable allows you to interact with the 'Tether' contract in your JavaScript code.
*/


// eslint-disable-next-line no-undef
const RWD = artifacts.require('RWD')
// eslint-disable-next-line no-undef
const Tether = artifacts.require('Tether')
// eslint-disable-next-line no-undef
const DecentralBank = artifacts.require('DecentralBank')

module.exports = async function(deployer, network, accounts) {
  
  // Deploy Mock Tether Token
  await deployer.deploy(Tether)
  const tether = await Tether.deployed()

  // Deploy RWD Token
  await deployer.deploy(RWD)
  const rwd = await RWD.deployed()

  // Deploy DecentralBank
  await deployer.deploy(DecentralBank, rwd.address, tether.address)
  const decentralBank = await DecentralBank.deployed()

  // Transfer all tokens to DecentralBank (1 million)
  await rwd.transfer(decentralBank.address, '1000000000000000000000000')

  // Transfer 100 Mock Tether tokens to investor
  await tether.transfer(accounts[1], '100000000000000000000')
}
