/* 
Need of Migrations.sol

Migration code, as seen in your provided Solidity contract, serves a specific purpose 
when working with the Truffle development framework and smart contract deployment on 
blockchain networks. Here's why migration code is essential:

Smart Contract Deployment: In blockchain development, you often have multiple 
versions of your smart contracts. As you develop and refine your dApp, you might need 
to deploy new versions of your smart contracts to the blockchain.

Maintaining State: Smart contracts on most blockchains are immutable once deployed. 
This means that you can't modify the code of a deployed contract directly. 
To update the logic of a contract or deploy a new version, you create a new contract. 
However, you want to maintain essential state information, such as the last completed 
migration.

Ownership and Permissions: Migration contracts often include an owner and access 
control mechanisms (e.g., the restricted modifier) to ensure that only authorized 
parties can trigger migrations. This is crucial for maintaining security and control 
over the deployment process.

Migration Sequencing: Migration code helps you sequence the deployment of multiple 
contracts. You can specify the order in which contracts should be deployed and the 
dependencies between them. This is important when one contract relies on another for 
its functionality.

EVM Interaction: The migration code can interact with the Ethereum Virtual Machine (EVM)
 to deploy new contracts, set initial values, or perform other tasks required for your 
 dApp's setup.

In your specific example, the Migrations contract keeps track of the last completed 
migration and allows the owner to set this value and upgrade the contract to a new 
address. This mechanism ensures that the dApp can maintain its state and control the 
deployment of new contract versions.
 */

pragma solidity >=0.5.0; // ^ means greater than or equal to 0.5.0

contract Migrations {
  address public owner;
  uint public last_completed_migration;

  constructor() public {
    owner = msg.sender;
  }

  modifier restricted() {
    if (msg.sender == owner) _;
  }

  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }

  function upgrade(address new_address) public restricted {
    Migrations upgraded = Migrations(new_address);
    upgraded.setCompleted(last_completed_migration);
  }
}
