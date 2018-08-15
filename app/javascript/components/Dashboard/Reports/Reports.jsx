import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../../BaseComponent'
import ButtonRadioGroup from '../../Forms/ButtonRadioGroup'
import ClientSideForm from '../../Forms/ClientSideForm'
import StatusTracker from '../../Utilities/StatusTracker'

import SelectContext from '../SelectContext'

import AttendanceReport from './AttendanceReport'
import GapReport from './GapReport';

const reportTypes = [
    { value: 'attendance', label: 'Attendance' },
    { value: 'gap', label: 'Gap' }
]

export default class Reports extends BaseComponent {
    static propTypes = {
        community: PropTypes.object.isRequired,
        campus: PropTypes.object,
        campuses: PropTypes.arrayOf(PropTypes.object),
        gathering: PropTypes.object,
        gatherings: PropTypes.arrayOf(PropTypes.object),
        routes: PropTypes.object.isRequired,
        reportType: PropTypes.oneOf(['attendance', 'gap']),
        onChange: PropTypes.func
    }

    constructor(props) {
        super(props)

        this.state = {
            campus: this.props.campus,
            campuses: this.props.campuses || [],
            gathering: this.props.gathering,
            gatherings: this.props.gatherings || [],
            reportType: this.props.reportType || 'attendance',
            reportStatus: new StatusTracker(reportTypes.map(reportType => reportType.value))
        }

        this.handleContextChange = this.handleContextChange.bind(this)
        this.handleReportChange = this.handleReportChange.bind(this)
        this.handleReady = this.handleReady.bind(this)
    }

    handleContextChange(json) {
        let campus = json['campus']
        let campuses = json['campuses'] || []
        let gathering = json['gathering']
        let gatherings = json['gatherings'] || []
        let state = this.state
        if (    state.campus != campus
            ||  state.campuses != campuses
            ||  state.gathering != gathering
            ||  state.gatherings != gatherings) {
            this.onChange({
                campus: campus,
                campuses: campuses,
                gathering: gathering,
                gatherings: gatherings
            })
        }
    }

    handleReady(id, isReady = false) {
        let state = this.state
        state.reportStatus.markReady(id, isReady)
        this.setState(state)
    }

    handleReportChange(json) {
        let state = this.state
        if (json['report_type'] != state.reportType) {
            this.setState({
                reportType: json['report_type'] || 'attendance'
            })
        }
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

    renderReport(state) {
        switch (state.reportType) {
            default:
            case 'attendance':
                return (
                    <AttendanceReport
                        id='attendance'
                        campus={state.campus}
                        gathering={state.gathering}
                        reportsPath={this.props.routes['reports_path']}
                        onReady={this.handleReady}
                    />
                )

            case 'gap':
                return (
                    <GapReport
                        id='gap'
                        community={this.props.community}
                        campus={state.campus}
                        reportsPath={this.props.routes['reports_path']}
                        onReady={this.handleReady}
                    />
                )
        }
    }

    render() {
        let state = this.state
        let disabled = state.reportStatus.isBusy(state.reportType)
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
                                    <ButtonRadioGroup
                                        label='Report Type'
                                        id={`${this.props.id}_report_type`}
                                        name='report_type'
                                        value={state.reportType}
                                        options={reportTypes}
                                        disabled={disabled}
                                        onChange={this.handleReportChange}
                                    />
                                    <SelectContext
                                        community={this.props.community}
                                        campus={state.campus}
                                        campuses={state.campuses}
                                        gathering={state.gathering}
                                        gatherings={state.gatherings}
                                        routes={this.props.routes}
                                        enableGatherings={state.reportType == 'attendance'}
                                        disabled={disabled}
                                        onChange={this.handleContextChange}
                                    />
                                </div>
                            </div>
                        </ClientSideForm>
                    </div>
                </div>
                <div className='col-10 align-self-center h-100'>
                    {this.renderReport(state)}
                </div>
            </div>
        )
    }
}
