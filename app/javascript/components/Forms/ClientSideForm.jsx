import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../BaseComponent'

import SubmitButton from './SubmitButton'

export default class ClientSideForm extends BaseComponent {
    static propTypes = {
        onSubmit: PropTypes.func
    }

    constructor(props) {
        super(props)
        this.id = Date.now()
        this.handleSubmit = this.handleSubmit.bind(this)
    }

    handleSubmit(event) {
        event.preventDefault()
        if (this.props.onSubmit) {
            let form = document.getElementById(this.id)
            let json = {}
            for (let item of (new FormData(form))) {
                json[item[0]] = item[1]
            }
            this.props.onSubmit(json)
        }
    }

    render() {
        return (
            <form className='mb-0' id={this.id} onSubmit={this.handleSubmit}>
                {this.props.children}
            </form>
        );
    }
}
