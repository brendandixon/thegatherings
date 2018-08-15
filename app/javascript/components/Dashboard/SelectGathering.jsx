import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../BaseComponent'
import LabeledSelect from '../Forms/LabeledSelect'
import { toInteger } from '../Utilities/Core'
import fetchTimeout from '../Utilities/FetchTimeout'
import { evaluateJSONResponse, readJSONResponse } from '../Utilities/HttpUtilities'

export default class SelectGathering extends BaseComponent {
    static propTypes = {
        id: PropTypes.string,
        community: PropTypes.object.isRequired,
        campus: PropTypes.object,
        gathering: PropTypes.object,
        gatherings: PropTypes.arrayOf(PropTypes.object),
        routes: PropTypes.object.isRequired,
        disabled: PropTypes.bool,
        onChange: PropTypes.func.isRequired
    }

    constructor(props) {
        super(props)
        this.state = {
            gathering: this.props.gathering,
            gatherings: this.props.gatherings || [],
        }

        this.ensureGatherings = this.ensureGatherings.bind(this)
        this.handleChange = this.handleChange.bind(this)
        this.handleError = this.handleError.bind(this)
        this.onChange = this.onChange.bind(this)
    }

    componentDidMount() {
        this.ensureGatherings()
    }

    componentDidUpdate(prevProps, prevState) {
        if (this.props.campus != prevProps.campus) {
            Promise
                .resolve()
                .then(() => this.onChange({ gathering: null, gatherings: [] }))
                .then(() => this.ensureGatherings())
        }
    }

    ensureGatherings() {
        let state = this.state
        if (state.gatherings.length <= 0) {
            let path = this.props.routes.gatherings_path
            if (this.props.campus) {
                path += `&campus_id=${this.props.campus.id}`
            }

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
                .then(json => this.onChange({ gathering: null, gatherings: json }))
                .catch(error => this.handleError(error))
        }
    }

    handleChange(json) {
        let gatheringId = toInteger(json['gathering_id'])
        let state = this.state
        let gathering = state.gatherings.find(g => g.id == gatheringId) || null
        if (state.gathering != gathering) {
            this.onChange({
                gathering: gathering,
                gatherings: state.gatherings
            })
        }
    }

    onChange(state) {
        if (state.gatherings.length == 1 && !state.gathering) {
            state.gathering = state.gatherings[0]
        }
        this.props.onChange({
            gathering: state.gathering,
            gatherings: state.gatherings
        })
        this.setState(state)
    }

    handleError(error) {
        console.log(error)
    }

    render() {
        let state = this.state
        let gatherings = state.gatherings.map(c => {
            return { value: c.id, label: c.name }
        })
        if (gatherings.length > 1) {
            gatherings.unshift({ value: -1, label: 'All Gatherings' })
        }
        let value = (state.gathering
                        ? state.gathering['id']
                        : -1).toString()
        return (
            <LabeledSelect
                className={this.props.className}
                hasFocus={true}
                disabled={this.props.disabled || state.gatherings.length <= 1}
                id={`${this.props.id}_gathering_id`}
                name='gathering_id'
                label={`Gathering`}
                size={1}
                options={gatherings}
                value={value}
                onChange={this.handleChange}
            />
        )
    }
}
