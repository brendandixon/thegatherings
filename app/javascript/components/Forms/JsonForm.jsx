import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../BaseComponent'
import fetchTimeout from '../Utilities/FetchTimeout'
import { evaluateJSONResponse, readJSONResponse } from '../Utilities/HttpUtilities'
import { formToJSON } from '../Utilities/RailsUtilities'

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

        fetchTimeout(this.props.action, {
            credentials: 'same-origin',
            method: this.props.method,
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json; charset=utf-8'
            },
            body: formToJSON(event.target)
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
