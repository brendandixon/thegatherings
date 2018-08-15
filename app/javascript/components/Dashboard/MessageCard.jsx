import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../BaseComponent'

import BaseCard from './BaseCard'

export default class MessageCard extends BaseComponent {
    static propTypes = {
        id: PropTypes.string.isRequired,
        message: PropTypes.string,
        title: PropTypes.string
    }

    constructor(props) {
        super(props)
    }

    render() {
        return (
            <BaseCard
                id={this.props.id}
                title={this.props.title}
            >
                <div className='display-4 text-muted text-center'>
                    {this.props.children}
                </div>
            </BaseCard>
        )
    }
}
