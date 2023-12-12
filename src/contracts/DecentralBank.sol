/*
this DApp of yield farming works on this rule

Full Unstaking Requirement:
Some yield farming platforms may require users to unstake the entire amount of tokens they initially staked. In this case, if you staked 100 'Tether' tokens, you would need to unstake all 100 tokens at once.
This approach simplifies the smart contract logic and ensures that users receive rewards in a consistent manner.
 */


// tokens == tether 
pragma solidity >=0.5.0;

import './RWD.sol';
import './Tether.sol';

contract DecentralBank {
  string public name = 'Decentral Bank';
  address public owner;
  Tether public tether;
  RWD public rwd;

  address[] public stakers;

  mapping(address => uint) public stakingBalance;
  mapping(address => bool) public hasStaked;
  mapping(address => bool) public isStaking;

constructor(RWD _rwd, Tether _tether) public {
    rwd = _rwd;
    tether = _tether;
    owner = msg.sender;
}

  // staking function   
function depositTokens(uint _amount) public {

  // require staking amount to be greater than zero
    require(_amount > 0, 'amount cannot be 0');
  
  // Transfer tether tokens to this contract address for staking
  tether.transferFrom(msg.sender, address(this), _amount);

  // Update Staking Balance
  stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

  if(!hasStaked[msg.sender]) {
    stakers.push(msg.sender);
  }

  // Update Staking Balance
    isStaking[msg.sender] = true;
    hasStaked[msg.sender] = true;
}

  // unstaking the whole 100 tethers 
  function unstakeTokens() public {
    uint balance = stakingBalance[msg.sender];
    // require the amount to be greater than zero
    require(balance > 0, 'staking balance cannot be less than zero');

    // transfer the tether back to address of customer who had staked & now wants to unstake from our bank
    // this is the transfer function from Tether.sol
    tether.transfer(msg.sender, balance);

    // reset staking balance
    stakingBalance[msg.sender] = 0;

    // Update Staking Status
    isStaking[msg.sender] = false;

  }

  // issue rewards
        function issueTokens() public {
            // Only owner can call this function
            require(msg.sender == owner, 'caller must be the owner');

            // issue tokens to all stakers
            for (uint i=0; i<stakers.length; i++) {
                address recipient = stakers[i]; 
                uint balance = stakingBalance[recipient] / 9;
                if(balance > 0) {
                rwd.transfer(recipient, balance);
            }
       }
       }
      
}