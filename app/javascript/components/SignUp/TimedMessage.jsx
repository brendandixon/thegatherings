import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../BaseComponent'
import ClientSideForm from '../Forms/ClientSideForm'

import SubmitStepButton from './SubmitStepButton'

export default class TimedMessage extends BaseComponent {
    static propTypes = {
        secondsDelay: PropTypes.number,
        submitTitle: PropTypes.string,
        onSuccess: PropTypes.func.isRequired
    }

    constructor(props) {
        super(props)
        this.secondsDelay = this.props.secondsDelay == null ? 5 : this.props.secondsDelay
        this.timerID = null
        this.handleSuccess = this.handleSuccess.bind(this)
    }

    componentDidMount() {
        if (this.secondsDelay > 0) {
            this.timerID = setInterval(
                () => this.handleSuccess(),
                this.secondsDelay * 1000
            )
        }
    }

    componentWillUnmount() {
        if (this.timerID) {
            clearInterval(this.timerID)
            this.timerID = null
        }
    }

    handleSuccess() {
        this.props.onSuccess()
    }

    render() {
        return (
            <ClientSideForm
                onSuccess={this.handleSuccess}
            >
                {this.props.children}
                <SubmitStepButton
                    title={this.props.submitTitle || 'Continue\u2026'}
                    position='right'
                />
            </ClientSideForm>
        )
    }
}
