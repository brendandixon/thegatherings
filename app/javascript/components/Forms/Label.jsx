import React from 'react'
import PropTypes from 'prop-types'
import BaseComponent from '../BaseComponent'

export default class Label extends BaseComponent {
    static propTypes = {
        for: PropTypes.string.isRequired,
        value: PropTypes.string.isRequired
    }

    constructor(props) {
        super(props)
    }

    render() {
        return (
            <label
                className='text-muted form-text'
                htmlFor={this.props.for}>
                {this.props.value}
            </label>
        );
    }
}
