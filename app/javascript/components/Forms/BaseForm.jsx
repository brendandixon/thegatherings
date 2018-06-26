import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../BaseComponent'

import RailsAuthenticator from './RailsAuthenticator'

export default class BaseForm extends BaseComponent {
    static propTypes = {
        action: PropTypes.string.isRequired,
        method: PropTypes.string.isRequired
    }

    constructor(props) {
        super(props)
    }

    render() {
        return (
            <form className='mb-0' action={this.props.action} method={this.props.method}>
                <RailsAuthenticator />
                {this.props.children}
            </form>
        );
    }
}
