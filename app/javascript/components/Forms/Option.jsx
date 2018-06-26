import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../BaseComponent'

export default class Option extends BaseComponent {
    static propTypes = {
        id: PropTypes.string.isRequired,
        value: PropTypes.oneOfType([
                    PropTypes.number,
                    PropTypes.string
                ]).isRequired,
        label: PropTypes.string.isRequired
    }

    constructor(props) {
        super(props)
    }

    render() {
        return (
            <option
                id={this.props.id}
                className='text-muted'
                value={this.props.value}
            >
                {this.props.label}
            </option>
        );
    }
}
