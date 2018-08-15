import React from 'react'
import PropTypes from 'prop-types'
import jQuery from 'jquery'

import BaseComponent from '../BaseComponent'
import LabeledSelect from '../Forms/LabeledSelect'
import { toInteger} from '../Utilities/Core'
import fetchTimeout from '../Utilities/FetchTimeout'
import { evaluateJSONResponse, readJSONResponse } from '../Utilities/HttpUtilities'

export default class SelectCampus extends BaseComponent {
    static propTypes = {
        id: PropTypes.string,
        community: PropTypes.object.isRequired,
        campus: PropTypes.object,
        campuses: PropTypes.arrayOf(PropTypes.object),
        routes: PropTypes.object.isRequired,
        disabled: PropTypes.bool,
        onChange: PropTypes.func.isRequired
    }

    constructor(props) {
        super(props)

        this.state = {
            campus: this.props.campus,
            campuses: this.props.campuses || []
        }

        this.ensureCampuses = this.ensureCampuses.bind(this)
        this.handleChange = this.handleChange.bind(this)
        this.handleError = this.handleError.bind(this)
    }

    componentDidMount() {
        this.ensureCampuses(this.state)
    }

    ensureCampuses(state) {
        let campuses = state.campuses || []
        let campus = campuses.length > 0 ? state.campus : null
        let promise = campuses.length <= 0
            ? fetchTimeout(this.props.routes.campuses_path, {
                credentials: 'same-origin',
                method: 'GET',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json; charset=utf-8'
                }
            })
                .then(readJSONResponse)
                .then(evaluateJSONResponse)
            : Promise.resolve(campuses)

        promise
            .then(json => this.onChange({ campus: campus, campuses: json }))
            .catch(error => this.handleError(error))
    }

    handleChange(json) {
        let campusId = toInteger(json['campus_id'])
        let state = this.state
        let campus = state.campuses.find(c => c.id == campusId) || null
        if (state.campus != campus) {
            this.onChange({
                campus: campus,
                campuses: state.campuses
            })
        }
    }

    onChange(state) {
        if (state.campuses.length == 1 && !state.campus) {
            state.campus = state.campuses[0]
        }
        this.props.onChange({
            campus: state.campus,
            campuses: state.campuses
        })
        this.setState(state)
    }

    handleError(error) {
        console.log(error)
    }

    render() {
        let state = this.state
        let campuses = state.campuses.map(c => {
            return { value: c.id, label: c.name }
        })
        if (campuses.length > 1) {
            campuses.unshift({ value: -1, label: 'All Campuses' })
        }
        return (
            <LabeledSelect
                hasFocus={false}
                disabled={this.props.disabled || state.campuses.length <= 1}
                id={`${this.props.id}_campus_id`}
                name='campus_id'
                label={`Campus`}
                size={1}
                options={campuses}
                value={(state.campus ? state.campus['id'] : -1).toString()}
                onChange={this.handleChange}
            />
        )
    }
}
