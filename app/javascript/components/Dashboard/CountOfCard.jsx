import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../BaseComponent'

import DataCard from './DataCard'

export default class CountOfCard extends BaseComponent {
    static propTypes = {
        id: PropTypes.string.isRequired,
        collection: PropTypes.array,
        path: PropTypes.string,
        title: PropTypes.string,
        onReady: PropTypes.func
    }

    constructor(props) {
        super(props)

        this.state = {
            collection: this.props.collection || []
        }

        this.handleReceive = this.handleReceive.bind(this)
    }

    handleReceive(json) {
        this.setState({
            collection: json || []
        })
    }

    render() {
        let state = this.state
        let collection = this.props.collection || state['collection'] || []
        return (
            <DataCard
                id={this.props.id}
                data={this.props.collection}
                path={this.props.path}
                title={this.props.title}
                onReceive={this.handleReceive}
                onReady={this.props.onReady}
            >
                {collection.length.toString()}
            </DataCard>
        )
    }
}
