import React, {Component} from 'react'
import Airdrop from './Airdrop'

class Main extends Component {
    render() {
        /*
        helps in debugging
        console.log(this.props.stakingBalance)
        console.log(this.props.tetherBalance)
        */
        return (
            <div id='content' className='mt-3'>
                <table className='table text-muted text-center'>
                    <thead>
                    <tr style={{color:'white'}}>
                        <th scope='col'>Staking Balance</th>
                        <th scope='col'>Reward Balance</th>
                    </tr>
                    </thead>
                    <tbody>
                        <tr style={{color:'white'}}> 
                            <td>{window.web3.utils.fromWei(this.props.stakingBalance, 'Ether')} USDT</td>
                            <td>{window.web3.utils.fromWei(this.props.rwdBalance, 'Ether')} RWD</td>
                        </tr>
                    </tbody>
                </table>
                <div className='card mb-2 ' style={{opacity:'.9',  padding:40}}>
                    <form 
                    onSubmit={(event) => {
                        event.preventDefault()
                        let amount
                        amount = this.input.value.toString()
                        amount = window.web3.utils.toWei(amount, 'Ether')
                        this.props.stakeTokens(amount)
                    }}
                    className='mb-3'>
                        <div style={{borderSpacing:'0 1em'}}>
                            <label className='float-left' style={{marginLeft:'15px'}}><b>How many Tokens (TETHER) you want to STAKE? </b></label>
                            <span className='float-right' style={{marginRight:'8px'}}>
                                Your Account Balance: {window.web3.utils.fromWei(this.props.tetherBalance, 'Ether')}
                            </span>
                            <div className='input-group mb-4'>
                                <input
                                ref={(input)=> {this.input = input} } 
                                type='text'
                                placeholder='0'
                                required />
                                <div className='input-group-open'>
                                    <div className='input-group-text'>
                                        <img src="https://media.tenor.com/95fjqy0Sre0AAAAC/usdt.gif" alt='tether' height='50' />
                                        &nbsp;&nbsp;&nbsp; USDT
                                    </div>
                                </div>
                            </div>
                            <button type='submit' className='btn btn-primary btn-lg btn-block'><b>DEPOSIT</b></button>
                        </div>
                    </form>
                    <button 
                    type='submit'
                    onClick={(event) => {
                        event.preventDefault(
                        this.props.unstakeTokens()
                        )
                    }}
                    className='btn btn-primary btn-lg btn-block'><b>WITHDRAW</b></button>
                    <div className='card-body text-center' style={{color:'blue'}}>
                    AIRDROP <Airdrop 
                    stakingBalance={this.props.stakingBalance}
                    decentralBankContract={this.props.decentralBankContract} />
                    </div>
                </div>
            </div>
        )
    }
}

export default Main;