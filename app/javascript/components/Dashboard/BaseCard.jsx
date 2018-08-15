import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../BaseComponent'

export default class BaseCard extends BaseComponent {
    static propTypes = {
        id: PropTypes.string.isRequired,
        title: PropTypes.string
    }

    constructor(props) {
        super(props)
    }

    renderTitle() {
        return this.props.title
            ? (
                <div className='card-header text-muted text-center'>
                    <div className='card-title display-6'>
                        {this.props.title}
                    </div>
                </div>
            )
            : null
    }

    render() {
        return (
            <div className={`card ${this.props.className}`}>
                <div className='card-body'>
                    {this.props.children}
                </div>
                {this.renderTitle()}
            </div>
        )
    }
}
