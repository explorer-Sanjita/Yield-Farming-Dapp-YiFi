// to issue reward tokens automatically when people stake tethers
// i.e. calling issueTokens() function from DecentalBank.sol automatically & issuing reward tokens to eveyrone who have staked their tethers
// callback function calls itself

/*

 */

// eslint-disable-next-line no-undef
const DecentralBank = artifacts.require('DecentralBank');

module.exports = async function issueRewards(callback) {
    let decentralBank = await DecentralBank.deployed()
    await decentralBank.issueTokens()
    console.log('Tokens have been issued successfully!')
    callback()
}