import React, {Component} from 'react'
import YiFi from '../YiFi.png'

class Navbar extends Component {
    render() {
        return (
            <nav className='navbar navbar-dark fixed-top shadow p-0' style={{backgroundColor:'black', height:'70px'}}>
                <a className='navbar-brand col-sm-3 col-md-2 mr-0' style={{color:'white',
            fontSize:25}}>
                <img src={YiFi} width='40' height='40' className='d-inline-block align-top' alt='YiFi LOGO'/>
                &nbsp; YiFi (DeFi Yield farming)
                </a>
                <ul className='navbar-nav px-3'>
                    <li className='text-nowrap d-none nav-item d-sm-none d-sm-block'>
                        <small style={{color:'white', fontSize:15}}>ACCOUNT NUMBER: {this.props.account}
                        </small>
                    </li>
                </ul>
            </nav>
        )
    }
}

export default Navbar;