import React, { Fragment } from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../../BaseComponent'
import ClientSideForm from '../../Forms/ClientSideForm'
import fetchTimeout from '../../Utilities/FetchTimeout'
import { addGroupsQuery, evaluateJSONResponse, readJSONResponse } from '../../Utilities/HttpUtilities'

import SelectContext from '../SelectContext'

import HealthRecord from './HealthRecord'

export default class Health extends BaseComponent {
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
            healthRecords: []
        }

        this.ensureHealth = this.ensureHealth.bind(this)
        this.handleContextChange = this.handleContextChange.bind(this)
        this.handleError = this.handleError.bind(this)
        this.onChange = this.onChange.bind(this)
        this.onReady = this.onReady.bind(this)
    }

    componentDidMount() {
        this.ensureHealth(this.state)
    }

    ensureHealth(state) {
        let props = this.props
        let group = state.campus || props.community

        this.onReady(false)

        console.log(state)
        console.log(group)
        fetchTimeout(group.health_path, {
            credentials: 'same-origin',
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json; charset=utf-8'
            }

        })
            .then(readJSONResponse)
            .then(evaluateJSONResponse)
            .then(json => this.setState({ healthRecords: json || []}))
            .then(() => this.onReady(true))
            .catch(error => this.handleError(error))
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
        this.ensureHealth(state)
        this.setState(state)
    }

    onReady(isReady = true) {
        this.setState({
            disabled: !isReady
        })
    }

    renderHealth(state) {
        return state.healthRecords.map(healthRecord => {
            return (
                <div
                    className='row justify-content-left pt-1'
                    key={`health-record-${healthRecord.gathering.id}`}
                >
                    <div className='col-12'>
                        <HealthRecord
                            id={Date.now().toString()}
                            healthRecord={healthRecord}
                        />
                    </div>
                </div>
            )
        })
    }

    render() {
        let state = this.state
        return (
            <Fragment>
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
                                            enableGatherings={false}
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
                            <div className='row justify-content-left pt-2 pb-1 text-muted'>
                                <div className='col-3'><span class='h4'>Gathering</span></div>
                                <div className='col-9'><span class='h4'>Scores</span></div>
                            </div>
                            {this.renderHealth(state)}
                        </div>
                    </div>
                </div>
            </Fragment>
        )
    }
}
