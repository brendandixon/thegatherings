import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../BaseComponent'
import ButtonRadioGroup from '../Forms/ButtonRadioGroup'
import ClientSideForm from '../Forms/ClientSideForm'
import LabeledSelect from '../Forms/LabeledSelect'
import SubmitButton from '../Forms/SubmitButton'
import { evaluateJSONResponse, readJSONResponse } from '../Utilities/HttpUtilities'

export default class SideBar extends BaseComponent {
    static propTypes = {
        id: PropTypes.string.isRequired,
        community: PropTypes.object.isRequired,
        campusId: PropTypes.number,
        disabled: PropTypes.bool,
        reportType: PropTypes.oneOf(['attendance', 'gap']),
        onChange: PropTypes.func
    }

    constructor(props) {
        super(props)
        this.state = {
            reportType: this.props.reportType,
            campuses: [],
            campusId: this.props.campusId,
            gatherings: [],
            gatheringId: null
        }

        this.reportTypes = [
            { value: 'attendance', label: 'Attendance' },
            { value: 'gap', label: 'Gap' }
        ]

        this.ensureCampuses = this.ensureCampuses.bind(this)
        this.ensureGatherings = this.ensureGatherings.bind(this)
        this.handleCampusChange = this.handleCampusChange.bind(this)
        this.handleError = this.handleError.bind(this)
        this.handleReportTypeChange = this.handleReportTypeChange.bind(this)
        this.handleSuccess = this.handleSuccess.bind(this)
        this.raiseOnChange = this.raiseOnChange.bind(this)
        this.toInteger = this.toInteger.bind(this)
    }

    componentDidMount() {
        this.ensureCampuses(this.state)
    }

    ensureCampuses() {
        fetch(this.props.community.campuses_path, {
            credentials: 'same-origin',
            method: 'GET'
        })
            .then(readJSONResponse)
            .then(evaluateJSONResponse)
            .then(json => this.setState({ campuses: json }))
            .then(() => this.ensureGatherings(this.state))
            .catch(error => this.handleError(error))
    }

    ensureGatherings(state) {
        let campusId = state.campusId
        let campus = state.campuses.find(c => c.id == campusId) || null
        if (campus) {
            fetch(campus.gatherings_path, {
                credentials: 'same-origin',
                method: 'GET'
            })
                .then(readJSONResponse)
                .then(evaluateJSONResponse)
                .then(json => this.setState({ gatherings: json }))
                .catch(error => this.handleError(error))
        }
    }

    handleCampusChange(json) {
        let campusId = this.toInteger(json['campus_id'])
        let state = this.state
        if (state.campusId != campusId) {
            state.campusId = campusId
            state.gatherings = []
            state.gatheringId = null
            this.ensureGatherings(state)
            this.setState(state)
        }
    }

    handleError(error) {
        // console.log("ERROR")
        // console.log(error)
    }

    handleSuccess(json) {
        let state = this.state
        let campusId = this.toInteger(json['campus_id'])
        let campus = state.campuses.find(c => c.id == campusId) || null
        let gatheringId = this.toInteger(json['gathering_id'])
        let gathering = state.gatherings.find(g => g.id == gatheringId) || null

        state.campusId = campusId
        state.campus = campus
        state.gatheringId = gatheringId
        state.gathering = gathering
        state.reportType = json['report_type'] || this.props.reportType

        this.raiseOnChange(state)
        this.setState(state)
    }

    handleReportTypeChange(json) {
        let state = this.state
        if (json['report_type'] != state.reportType) {
            state.reportType = json['report_type'] || 'attendance'
            this.raiseOnChange(state)
            this.setState(state)
        }
    }

    raiseOnChange(state) {
        if (this.props.onChange) {
            this.props.onChange({
                campus: state.campus,
                gathering: state.gathering,
                reportType: state.reportType
            })
        }
    }

    toInteger(id) {
        id = id ? parseInt(id) : NaN
        if (id == NaN) {
            id = -1
        }
        if (id < 0) {
            id = null
        }
        return id
    }

    renderReportTypes(state) {
        return (
            <ButtonRadioGroup
                label='Report Type'
                id={`${this.props.id}_report_type`}
                name='report_type'
                value={state.reportType}
                options={this.reportTypes}
                onChange={this.handleReportTypeChange}
            />
        )
    }

    renderCampuses(state) {
        let campuses = state.campuses.map(c => {
            return { value: c.id, label: c.name }
        })
        if (campuses.length > 1) {
            campuses.unshift({ value: -1, label: 'All Campuses' })
        }
        return (
            <LabeledSelect
                hasFocus={false}
                disabled={this.props.disabled}
                id={`${this.props.id}_campus_id`}
                name='campus_id'
                label={`Campus`}
                size={1}
                options={campuses}
                value={(state.campusId || -1).toString()}
                onChange={this.handleCampusChange}
            />
        )
    }

    renderGatherings(state) {
        if (state.reportType != 'attendance' || !state.campusId) {
            return null
        }

        let gatherings = state.gatherings.map(c => {
            return { value: c.id, label: c.name }
        })
        if (gatherings.length > 1) {
            gatherings.unshift({ value: -1, label: 'All Gatherings' })
        }
        return (
            <LabeledSelect
                hasFocus={true}
                disabled={this.props.disabled || state.reportType != 'attendance'}
                id={`${this.props.id}_gathering_id`}
                name='gathering_id'
                label={`Gathering`}
                size={1}
                options={gatherings}
                value={(state.gatheringId || -1).toString()}
            />
        )
    }

    render() {
        let state = this.state
        return (
            <ClientSideForm
                id={this.props.id}
                disabled={!this.props.enabled}
                onSuccess={this.handleSuccess}
            >
                <div className='row no-gutters'>
                    <div className='col'>
                        {this.renderReportTypes(state)}
                        {this.renderCampuses(state)}
                        {this.renderGatherings(state)}
                        <SubmitButton
                            disabled={this.props.disabled}
                            title={this.props.disabled ? 'Refreshing...' : 'Refresh'}
                            position='full'
                        />
                    </div>
                </div>
            </ClientSideForm>
        )
    }
}
