import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../../BaseComponent'

import CountOfCard from '../CountOfCard'

export default class RequestsCard extends BaseComponent {
    static propTypes = {
        id: PropTypes.string.isRequired,
        community: PropTypes.object.isRequired,
        campus: PropTypes.object,
        onReady: PropTypes.func
    }

    constructor(props) {
        super(props)
    }

    render() {
        let props = this.props
        let path = (props.campus || props.community).requests_path
        return (
            <CountOfCard
                id={this.props.id}
                path={path}
                title='Outstanding Requests'
                onReady={this.props.onReady}
            />
        )
    }
}
