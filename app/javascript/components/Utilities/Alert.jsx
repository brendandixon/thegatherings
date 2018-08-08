import React from 'react'
import PropTypes from 'prop-types'
import jQuery from 'jquery'

import BaseComponent from '../BaseComponent'

export default class Alert extends BaseComponent {
    static propTypes = {
        messages: PropTypes.arrayOf(PropTypes.string),
        category: PropTypes.oneOf(['primary', 'secondary', 'success', 'danger', 'warning', 'info', 'light', 'dark']).isRequired,
        onClose: PropTypes.func
    }

    constructor(props) {
        super(props)
        this.state = {visible: true}
        this.handleClose = this.handleClose.bind(this)
    }

    handleClose(event) {
        event.preventDefault()
        this.setState({visible: false})
        if (this.props.onClose) {
            this.props.onClose()
        }
    }

    renderClose() {
        return (
            <button className='close' onClick={this.handleClose}>
                <span>&times;</span>
            </button>
        )
    }

    render() {
        const isVisible = this.state.visible && (this.props.messages && this.props.messages.length > 0)
        const canClose = jQuery.isFunction(this.props.onClose)
        const classes = `alert ${canClose ? 'alert-dismissible' : ''} fade alert-${this.props.category} ${isVisible ? 'show d-block' : 'hide d-none'}`
        const messages = this.props.messages && this.props.messages.length > 0
                            ?   <ul className='list-unstyled p-0 m-0'>
                                    {this.props.messages.map(message => <li key={message}>{message}</li>)}
                                </ul>
                            : ''
        return (
            <div
                className={classes}
                role='alert'
            >
                {canClose ? this.renderClose() : null}
                {messages}
            </div>
        );
    }
}
