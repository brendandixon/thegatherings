import React from 'react'
import PropTypes from 'prop-types'
import jQuery from 'jquery'

import BaseComponent from '../BaseComponent'

import AttendanceReport from './AttendanceReport'
import SideBar from './SideBar'
import GapReport from './GapReport';

export default class Reports extends BaseComponent {
    static propTypes = {
        community: PropTypes.object.isRequired,
        reportsPath: PropTypes.string.isRequired
    }

    constructor(props) {
        super(props)
        this.state = {
            campus: null,
            gathering: null,
            reportType: 'attendance',
            status: 'ready'
        }

        this.handleChange = this.handleChange.bind(this)
        this.handleReady = this.handleReady.bind(this)
    }

    handleChange(json) {
        let state = this.state
        let campus = json['campus'] || null
        let gathering = json['gathering'] || null
        let status = campus != state.campus || gathering != state.gathering
                        ? 'refreshing'
                        : 'ready'

        this.setState({
            campus: campus,
            gathering: gathering,
            reportType: json['reportType'] || 'attendance',
            status: status
        })
    }

    handleReady() {
        this.setState({
            status: 'ready'
        })
    }

    renderReport(state) {
        switch (state.reportType) {
            default:
            case 'attendance':
                return (
                    <AttendanceReport
                        campus={state.campus}
                        gathering={state.gathering}
                        reportsPath={this.props.reportsPath}
                        onReady={this.handleReady}
                    />
                )

            case 'gap':
                return (
                    <GapReport
                        community={this.props.community}
                        campus={state.campus}
                        reportsPath={this.props.reportsPath}
                        onReady={this.handleReady}
                    />
                )
        }
    }

    render() {
        let state = this.state
        return (
            <div className='row'>
                <div className='col-2 bg-light'>
                    <div className='p-2'>
                        <SideBar
                            id={Date.now().toString()}
                            community={this.props.community}
                            campusId={state.campus ? state.campus.id : null}
                            gatheringId={state.gathering ? state.gathering.id : null}
                            reportType={state.reportType}
                            disabled={state.status != 'ready'}
                            onChange={this.handleChange}
                        />
                    </div>
                </div>
                <div className='col-9 align-self-center h-100'>
                    {this.renderReport(state)}
                </div>
            </div>
        )
    }
}
