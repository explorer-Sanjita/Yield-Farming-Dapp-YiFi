/* 
In this yield farming DApp, if someone deposits tether in our bank , he or she will get some reward tokens
RWD == reward

In your yield farming DApp, you have a contract named `RWD.sol` that represents a Reward Token. It appears that you are planning to distribute these reward tokens to users who deposit Tether (USDT) into your yield farming bank. Here's how third-party transactions could be involved in your DApp, and why they might be needed:

1. **User Interaction**:
   - A user interacts with your DApp to deposit Tether into your bank contract. This interaction involves sending a transaction to the Tether contract to approve the bank contract to spend a certain amount of USDT on behalf of the user. This is a third-party transaction because it involves two different contracts (USDT and your bank contract).

     ```javascript
     // In the DApp UI, a user approves the bank contract to spend USDT on their behalf.
     usdtToken.approve(bankContractAddress, depositAmount);
     ```

2. **Deposit in Bank**:
   - After the approval is granted, the user initiates another transaction to deposit USDT into your bank contract. This transaction is also a third-party transaction because it involves interaction with the USDT contract.

     ```javascript
     // In the DApp UI, the user deposits USDT into the bank contract.
     bankContract.deposit(usdtAmount);
     ```

3. **Reward Distribution**:
   - Once the user has deposited USDT into your bank contract, your DApp calculates and rewards them with your Reward Token (RWD). This involves minting new RWD tokens and transferring them to the user. These reward token transactions are initiated from within your bank contract.

     ```solidity
     // In your bank contract's deposit function
     function deposit(uint256 _usdtAmount) public {
         // ... (deposit logic)

         // Mint and distribute RWD tokens to the user
         rewardToken.mintRewardTokens(msg.sender, rewardAmount);
     }
     ```

4. **Minting RWD Tokens**:
   - The `mintRewardTokens` function within your bank contract is responsible for creating new RWD tokens and transferring them to the user's address. This is typically an internal transaction within the bank contract.

     ```solidity
     // In your bank contract's mintRewardTokens function
     function mintRewardTokens(address _recipient, uint256 _amount) internal {
         // Mint new RWD tokens
         rewardToken.mint(_recipient, _amount);
     }
     ```

In summary, third-party transactions are necessary in your yield farming DApp because they involve interactions with external contracts, such as the USDT contract, to approve and transfer tokens. These interactions are essential for users to deposit USDT into your bank and receive your Reward Tokens (RWD) as rewards. Your bank contract acts as an intermediary between the user and the external token contracts, facilitating these transactions and reward distributions.
*/

pragma solidity >=0.5.0;

contract RWD {
    string  public name = "Reward Token";
    string  public symbol = "RWD";
    uint256 public totalSupply = 1000000000000000000000000; // 1 million tokens
    uint8   public decimals = 18;

    event Transfer(
        address indexed _from,
        address indexed _to, 
        uint _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender, 
        uint _value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    constructor() public {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        // require that the value is greater or equal for transfer
        require(balanceOf[msg.sender] >= _value);
         // transfer the amount and subtract the balance
        balanceOf[msg.sender] -= _value;
        // add the balance
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        // add the balance for transferFrom
        balanceOf[_to] += _value;
        // subtract the balance for transferFrom
        balanceOf[_from] -= _value;
        allowance[msg.sender][_from] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}
