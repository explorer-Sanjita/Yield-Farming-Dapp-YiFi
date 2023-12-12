/*
The transfer function allows an Ethereum address (msg.sender) to send a specified amount of tokens to another address (_to).
The approve function allows the owner of a token (msg.sender) to approve another address (_spender) to spend a certain number of tokens on their behalf.
The transferFrom function is used when someone other than the token owner (msg.sender) wants to transfer tokens from the owner's address (_from) to another address (_to).
In summary, transfer is used for direct transfers of tokens from the sender's account to another account, while transferFrom is used when a third party is approved to move tokens from one account to another on behalf of the token owner. The approve function is used to set the allowance for such third-party transfers. These functions collectively enable more complex token transfer scenarios and are essential for the functionality of many ERC-20 tokens on the Ethereum blockchain.

 */



pragma solidity >=0.5.0;

contract Tether {
    string  public name = "Mock Tether Token";
    string  public symbol = "mUSDT";
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
        balanceOf[msg.sender] = totalSupply; // contract address should have 1 million tokens
    }

/*
Example to understand mappings & functions
Allowance Concept:

In the context of Ethereum token contracts, "allowance" refers to the permission granted by a token holder (owner) to another Ethereum address (spender) to spend a certain number of tokens from their balance.
For example, if Alice owns 1,000 tokens and she wants to allow Bob to spend 200 of those tokens on her behalf (e.g., for a specific purpose or transaction), she sets the allowance for Bob's address in the allowance mapping to 200.
This allowance mechanism is commonly used in token contracts to enable more flexible and controlled token transfers, such as allowing decentralized applications (dApps) or smart contracts to spend tokens on behalf of users without giving them full control over the entire token balance.
Usage:

Token owners can use the approve function to set allowances for specific addresses. For example, Alice can call approve(Bob, 200) to allow Bob to spend up to 200 tokens from her balance.
The transferFrom function, which we discussed earlier, is typically used by the spender (e.g., Bob) to transfer tokens on behalf of the owner (e.g., Alice) as long as the amount being transferred is within the allowed limit.
When Bob calls transferFrom(Alice, Carol, 150), the contract checks that Bob has been allowed by Alice to spend at least 150 tokens on her behalf. If so, the tokens are transferred from Alice to Carol, and the allowance is updated accordingly.
 */



// owner transfers to sender himself/herself
// eg. Alice transfers herself
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

// Alice approves that Bob can spend 200eth on her behalf, Bob is spender
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

// Bob(third party) can transfer from Alice's account amt <= 200eth to Monica's account on behalf of Alice 
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from]); // Alice should have sufficient balance
        require(_value <= allowance[_from][msg.sender]); 
        // amt transferred by Bob should be less than or equal to the amt Alice has approved, eg Bob can't transfer 300eth
        // add the balance for transferFrom
        balanceOf[_to] += _value;
        // subtract the balance for transferFrom
        balanceOf[_from] -= _value;
        allowance[msg.sender][_from] -= _value;
        // mapping(address => mapping(address => uint256)) public allowance;
        // if 150eth are transferred , now bob can transfer only <=50eth next time on behalf of Alice

        /*
        The inner mapping also uses Ethereum addresses (address) as keys. It maps the owner's address to an unsigned integer (uint256), representing the amount of tokens that another address (the spender) is allowed to transfer on behalf of the owner.
So, in essence, allowance is a data structure that keeps track of who is allowed to spend how many tokens on behalf of various token owners.
*/
        emit Transfer(_from, _to, _value);
        return true;
    }

   
}
