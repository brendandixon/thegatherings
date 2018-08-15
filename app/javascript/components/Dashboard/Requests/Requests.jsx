import React, { Fragment } from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../../BaseComponent'
import ClientSideForm from '../../Forms/ClientSideForm'
import fetchTimeout from '../../Utilities/FetchTimeout'
import { addGroupsQuery, evaluateJSONResponse, readJSONResponse } from '../../Utilities/HttpUtilities'

import SelectContext from '../SelectContext'

import RequestCard from './RequestCard'

const statuses = [
    { value: 'unanswered', name: 'Unanswered' },
    { value: 'inprocess', name: 'In Process' },
    { value: 'accepted', name: 'Accepted' },
    { value: 'dismissed', name: 'Dismissed' }
]

export default class Requests extends BaseComponent {
    static propTypes = {
        community: PropTypes.object.isRequired,
        campus: PropTypes.object,
        campuses: PropTypes.arrayOf(PropTypes.object),
        gathering: PropTypes.object,
        gatherings: PropTypes.arrayOf(PropTypes.object),
        routes: PropTypes.object.isRequired,
        onChange: PropTypes.func
    }

    constructor(props) {
        super(props)

        this.state = {
            campus: this.props.campus,
            campuses: this.props.campuses || [],
            gathering: this.props.gathering,
            gatherings: this.props.gatherings || [],
            disabled: false,
            requests: {}
        }

        this.setRequests = this.setRequests.bind(this)
        this.ensureRequests = this.ensureRequests.bind(this)
        this.handleContextChange = this.handleContextChange.bind(this)
        this.handleError = this.handleError.bind(this)
        this.onChange = this.onChange.bind(this)
        this.onReady = this.onReady.bind(this)
    }

    componentDidMount() {
        this.ensureRequests(this.state)
    }

    ensureRequests(state) {
        let props = this.props
        let path = addGroupsQuery(props.community.requests_path, state)

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
            .then(json => this.setRequests(json || []))
            .then(() => this.onReady(true))
            .catch(error => this.handleError(error))
    }

    setRequests(json) {
        let requests = {
            all: [],
            unanswered: [],
            inprocess: [],
            accepted: [],
            dismissed: []
        }

        for (let request of json) {
            requests.all.push(request)
            requests[request.status].push(request)
        }

        this.setState({
            requests: requests
        })
    }

    handleContextChange(json) {
        let campus = json['campus']
        let campuses = json['campuses'] || []
        let gathering = json['gathering']
        let gatherings = json['gatherings'] || []
        let state = this.state
        if (state.campus != campus
            || state.campuses != campuses
            || state.gathering != gathering
            || state.gatherings != gatherings) {
            this.onChange({
                campus: campus,
                campuses: campuses,
                gathering: gathering,
                gatherings: gatherings,
                requests: {}
            })
        }
    }

    handleError(error) {
        console.log(error)
        this.onReady()
    }

    onChange(state) {
        if (this.props.onChange) {
            this.props.onChange({
                campus: state.campus,
                campuses: state.campuses,
                gathering: state.gathering,
                gatherings: state.gatherings
            })
        }
        this.ensureRequests(state)
        this.setState(state)
    }

    onReady(isReady = true) {
        this.setState({
            disabled: !isReady
        })
    }

    renderRequests(state, status) {
        let requests = state.requests[status.value] || []
        let cards = requests.map(request => {
            let campus = state.campuses.find(c => c.id == request.campus_id)
            let gathering = state.gatherings.find(g => g.id == request.gathering_id)
            return (
                <RequestCard
                    id={Date.now().toString()}
                    key={`request-${request.id}`}
                    className='mb-1'
                    campus={campus}
                    gathering={gathering}
                    request={request}
                />
            )
        })
        return (
            <Fragment>
                <div className='display-6 text-muted text-center mb-4'>{status.name}</div>
                {cards}
            </Fragment>
        )
    }

    render() {
        let state = this.state
        let columns = statuses.map(status => {
            return (
                <div key={status.value} className='col-3'>
                    {this.renderRequests(state, status)}
                </div>
            )
        })
        return (
            <div className='row'>
                <div className='col-2 bg-light'>
                    <div className='p-2'>
                        <ClientSideForm
                            id={this.props.id}
                        >
                            <div className='row no-gutters'>
                                <div className='col'>
                                    <SelectContext
                                        community={this.props.community}
                                        campus={state.campus}
                                        campuses={state.campuses}
                                        gathering={state.gathering}
                                        gatherings={state.gatherings}
                                        routes={this.props.routes}
                                        enableGatherings={true}
                                        disabled={state.disabled}
                                        onChange={this.handleContextChange}
                                    />
                                </div>
                            </div>
                        </ClientSideForm>
                    </div>
                </div>
                <div className='col-10 align-self-center h-100 p-3'>
                    <div className='container'>
                        <div className='row justify-content-center pt-2 requests'>
                            {columns}
                        </div>
                    </div>
                </div>
            </div>
        )
    }
}
