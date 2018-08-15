import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../../BaseComponent'
import ClientSideForm from '../../Forms/ClientSideForm'
import { addGroupsQuery } from '../../Utilities/HttpUtilities'
import StatusTracker from '../../Utilities/StatusTracker'

import CountOfCard from '../CountOfCard'
import SelectContext from '../SelectContext'

import AttendanceCard from './AttendanceCard'
import AttendeesCard from './AttendeesCard'
import RequestsCard from './RequestsCard'

const cards = [
    'gathering_count',
    'requests_count',
    'attendance_details',
    'attendee_details'
]

export default class Reports extends BaseComponent {
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
            cardStatus: new StatusTracker(cards)
        }

        this.handleContextChange = this.handleContextChange.bind(this)
        this.handleReady = this.handleReady.bind(this)
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
                gatherings: gatherings
            })
        }
    }

    handleReady(id, isReady = true) {
        let state = this.state
        state.cardStatus.markReady(id, isReady)
        this.setState(state)
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
        this.setState(state)
    }

    renderCards(state) {
        let cards = [
            <CountOfCard
                id='gathering_count'
                key='gathering_count'
                collection={state.gatherings}
                title='Gatherings'
            />,
            <RequestsCard
                id='requests_count'
                key='requests_count'
                community={this.props.community}
                campus={state.campus}
                gathering={state.gathering}
                onReady={this.handleReady}
            />,
            <AttendanceCard
                id='attendance_details'
                key='attendance_details'
                community={this.props.community}
                campus={state.campus}
                gathering={state.gathering}
                reportsPath={this.props.routes['reports_path']}
                onReady={this.handleReady}
            />,
            <AttendeesCard
                id='attendee_details'
                key='attendee_details'
                community={this.props.community}
                campus={state.campus}
                gathering={state.gathering}
                onReady={this.handleReady}
            />
        ]
        return (
            <div className='container'>
                <div className='row justify-content-center'>
                    <div className='card-columns'>
                        {cards}
                    </div>
                </div>
            </div>
        )
    }

    render() {
        let state = this.state
        let disabled = !state.cardStatus.allReady()
        let groups = {
            community: this.props.community,
            campus: state.campus
        }
        let kioskPath = addGroupsQuery(this.props.routes['signup_path'], groups)
        return (
            <div className='row'>
                <div className='col-2 bg-light'>
                    <div className='p-2'>
                        <ClientSideForm
                            id={this.props.id}
                            disabled={disabled}
                        >
                            <div className='row no-gutters'>
                                <div className='col'>
                                    <SelectContext
                                        community={this.props.community}
                                        campus={state.campus}
                                        campuses={state.campuses}
                                        gathering={state.gathering}
                                        gatherings={state.gatherings}
                                        enableGatherings={false}
                                        routes={this.props.routes}
                                        disabled={disabled}
                                        onChange={this.handleContextChange}
                                    />
                                </div>
                                <a
                                    href={kioskPath}
                                    className='w-100 btn btn-outline-primary'
                                    target='_blank'
                                    role='button'
                                >
                                    Launch Kiosk
                                </a>
                            </div>
                        </ClientSideForm>
                    </div>
                </div>
                <div className='col-10 align-self-center h-100 p-3'>
                    {this.renderCards(state)}
                </div>
            </div>
        )
    }
}
