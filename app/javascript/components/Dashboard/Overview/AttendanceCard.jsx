import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../../BaseComponent'

import DataCard from '../DataCard'

export default class AttendanceCard extends BaseComponent {
    static propTypes = {
        id: PropTypes.string.isRequired,
        community: PropTypes.object,
        campus: PropTypes.object,
        gathering: PropTypes.object,
        reportsPath: PropTypes.string,
        onReady: PropTypes.func
    }

    constructor(props) {
        super(props)

        this.state = {
            absent: null,
            present: null,
            meetings: null
        }

        this.handleReceive = this.handleReceive.bind(this)
    }

    handleReceive(json) {
        json = json || {}
        let averages = json['averages'] || {}
        this.setState({
            absent: averages['absent'],
            present: averages['present'],
            meetings: json['meetings']
        })
    }

    render() {
        let state = this.state
        return (
            <DataCard
                id={this.props.id}
                community={this.props.community}
                campus={this.props.campus}
                gathering={this.props.gathering}
                path={this.props.reportsPath + '/attendance'}
                title='Attendance'
                onReceive={this.handleReceive}
                onReady={this.props.onReady}
            >
                <div className='display-7 text-muted'>
                    <div>Average Absent: {state.absent}</div>
                    <div>Average Present: {state.present}</div>
                    <div>Total Meetings: {state.meetings}</div>
                </div>
            </DataCard>
        )
    }
}
