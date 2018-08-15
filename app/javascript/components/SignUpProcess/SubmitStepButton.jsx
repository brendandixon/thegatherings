import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../BaseComponent';
import SubmitButton from '../Forms/SubmitButton'

export default class SubmitStepButton extends BaseComponent {
    static propTypes = {
        title: PropTypes.string,
    }

    constructor(props) {
        super(props)
        this._submitButton = null
    }

    render() {
        return (
            <SubmitButton
                title={this.props.title || 'Continue\u2026'}
                position='right'
            />
        )
    }
}
