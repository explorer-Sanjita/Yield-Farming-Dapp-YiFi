/* eslint-disable no-undef */
/*
Mocha organizes your tests into suites and cases, handles setup and teardown, and manages the test lifecycle.

Chai provides expressive and readable ways to specify the expected behavior of your code within those tests. It allows you to make assertions about contract states, function return values, and other aspects of your contract interactions.

Here's how they work together:

Defining Tests: Mocha is used to define the test structure. You use describe to create test suites and it to define individual test cases.

Making Assertions: Within each it block, you use Chai's assertion methods to specify what you expect your code to do. For example, you can use should, expect, or assert styles provided by Chai to make various types of assertions.

Running Tests: Mocha takes care of running the tests and reporting the results. It executes the tests you've defined using the Mocha command-line interface or a test runner like truffle test.
*/

// tokens == tether 

const RWD = artifacts.require('RWD')
const Tether = artifacts.require('Tether')
const DecentralBank = artifacts.require('DecentralBank')

require('chai')
.use(require('chai-as-promised'))
.should()

contract('DecentralBank', ([owner, customer]) => {
    let tether, rwd, decentralBank

    function tokens(number) {
        return web3.utils.toWei(number, 'ether')
    }

    before(async () => {
        // Load Contracts
        tether = await Tether.new()
        rwd = await RWD.new()
        decentralBank = await DecentralBank.new(rwd.address, tether.address)

        // Transfer all tokens to DecentralBank (1 million)
        await rwd.transfer(decentralBank.address, tokens('1000000'))

        // Transfer 100 mock Tethers to Customer
        await tether.transfer(customer, tokens('100'), {from: owner})
    })
    

    describe('Mock Tether Deployment', async () => {
        it('matches name successfully', async () => {
            const name = await tether.name()
            assert.equal(name, 'Mock Tether Token') 
        })
    })

    describe('Reward Token Deployment', async () => {
        it('matches name successfully', async () => {
            const name = await rwd.name()
            assert.equal(name, 'Reward Token') 
        })
    })

    describe('Decentral Bank Deployment', async () => {
        it('matches name successfully', async () => {
            const name = await decentralBank.name()
            assert.equal(name, 'Decentral Bank') 
        })

        it('contract has tokens', async () => {
            let balance = await rwd.balanceOf(decentralBank.address)
            assert.equal(balance, tokens('1000000'))
        })

    describe('Yield Farming', async () => {
        it('rewards tokens for staking', async () => {
            let result

            // Check Investor Balance
            result = await tether.balanceOf(customer)
            assert.equal(result.toString(), tokens('100'), 'customer mock wallet balance before staking')
            
            // Check Staking For Customer of 100 tokens
            await tether.approve(decentralBank.address, tokens('100'), {from: customer})
            await decentralBank.depositTokens(tokens('100'), {from: customer})

            // Check Updated Balance of Customer
            result = await tether.balanceOf(customer)
            assert.equal(result.toString(), tokens('0'), 'customer mock wallet balance after staking 100 tokens')     
            
            // Check Updated Balance of Decentral Bank
            result = await tether.balanceOf(decentralBank.address)
            assert.equal(result.toString(), tokens('100'), 'decentral bank mock wallet balance after staking from customer')     
            
            // Is Staking Update
            result = await decentralBank.isStaking(customer)
            assert.equal(result.toString(), 'true', 'customer is staking status after staking')

            // Issue Tokens
            await decentralBank.issueTokens({from: owner})

            // Ensure Only The Owner Can Issue Tokens, if customer issues reward tokens it should be rejected
            await decentralBank.issueTokens({from: customer}).should.be.rejected;

            // Unstake Tokens function can be called only by the customer
            await decentralBank.unstakeTokens({from: customer})

            // Check Unstaking Balances
            // Full Unstaking
            // customer should have 100 Tether after unstaking
            result = await tether.balanceOf(customer)
            assert.equal(result.toString(), tokens('100'), 'customer mock wallet balance after unstaking')     
            
            // Check Updated Balance of Decentral Bank
            result = await tether.balanceOf(decentralBank.address)
            assert.equal(result.toString(), tokens('0'), 'decentral bank mock wallet balance after staking from customer')     
            
            // Is Staking Update
            result = await decentralBank.isStaking(customer)
            assert.equal(result.toString(), 'false', 'customer is no longer staking after unstaking')
        })
    })
    })
})