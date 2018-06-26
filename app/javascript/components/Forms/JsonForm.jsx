import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../BaseComponent'
import { evaluateJSONResponse, readJSONResponse } from '../Utilities/HttpUtilities'

import RailsAuthenticator from './RailsAuthenticator'

export default class JsonForm extends BaseComponent {
    static propTypes = {
        action: PropTypes.string.isRequired,
        method: PropTypes.string.isRequired,
        onSuccess: PropTypes.func.isRequired,
        onError: PropTypes.func.isRequired
    }

    constructor(props) {
        super(props)
        this.handleSubmit = this.handleSubmit.bind(this)
    }

    handleSubmit(event) {
        event.preventDefault()
        let data = new FormData(event.target)
        fetch(this.props.action, {
            credentials: 'same-origin',
            method: this.props.method,
            body: data
        })
        .then(readJSONResponse)
        .then(evaluateJSONResponse)
        .then(json => this.props.onSuccess(json))
        .catch(error => this.props.onError(error))
    }

    render() {
        return (
            <form className='mb-0' onSubmit={this.handleSubmit}>
                <RailsAuthenticator />
                {this.props.children}
            </form>
        );
    }
}
