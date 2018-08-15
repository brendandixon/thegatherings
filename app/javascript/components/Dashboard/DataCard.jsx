import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../BaseComponent'
import fetchTimeout from '../Utilities/FetchTimeout'
import { addGroupsQuery, evaluateJSONResponse, readJSONResponse } from '../Utilities/HttpUtilities'

import MessageCard from './MessageCard'

export default class DataCard extends BaseComponent {
    static propTypes = {
        id: PropTypes.string.isRequired,
        data: PropTypes.oneOfType([
            PropTypes.object,
            PropTypes.arrayOf(PropTypes.object)
        ]),
        community: PropTypes.object,
        campus: PropTypes.object,
        gathering: PropTypes.object,
        path: PropTypes.string,
        title: PropTypes.string,
        onReceive: PropTypes.func.isRequired,
        onReady: PropTypes.func
    }

    constructor(props) {
        super(props)

        this.ensureData = this.ensureData.bind(this)
        this.handleError = this.handleError.bind(this)
        this.onReady = this.onReady.bind(this)
    }

    componentDidMount() {
        if (!this.props.data) {
            this.ensureData()
        }
    }

    componentDidUpdate(prevProps, prevState) {
        let props = this.props
        if (   props.data != prevProps.data
            || props.path != prevProps.path
            || props.community != prevProps.community
            || props.campus != prevProps.campus
            || props.gathering != prevProps.gathering) {
            Promise
                .resolve()
                .then(() => this.onReady(false))
                .then(() => this.props.onReceive(null))
                .then(() => this.ensureData())
        }
    }

    ensureData() {
        if (this.props.path) {
            let path = addGroupsQuery(this.props.path, this.props)

            this.onReady(false)

            fetchTimeout(path, {
                credentials: 'same-origin',
                method: 'GET',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json; charset=utf-8'
                }

            })
                .then(readJSONResponse)
                .then(evaluateJSONResponse)
                .then(json => this.props.onReceive(json))
                .then(() => this.onReady(true))
                .catch(error => this.handleError(error))
        }
    }

    handleError(error) {
        console.log(error)
        this.onReady(true)
    }

    onReady(isReady = true) {
        if (this.props.onReady) {
            this.props.onReady(this.props.id, isReady)
        }
    }

    render() {
        return (
            <MessageCard
                id={this.props.id}
                title={this.props.title}
            >
                {this.props.children}
            </MessageCard>
        )
    }
}
