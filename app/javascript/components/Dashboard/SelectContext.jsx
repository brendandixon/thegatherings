import React, { Fragment } from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../BaseComponent'

import SelectCampus from './SelectCampus'
import SelectGathering from './SelectGathering'

export default class SelectContext extends BaseComponent {
    static propTypes = {
        id: PropTypes.string,
        community: PropTypes.object.isRequired,
        campus: PropTypes.object,
        campuses: PropTypes.arrayOf(PropTypes.object),
        gathering: PropTypes.object,
        gatherings: PropTypes.arrayOf(PropTypes.object),
        routes: PropTypes.object.isRequired,
        enableGatherings: PropTypes.bool,
        disabled: PropTypes.bool,
        onChange: PropTypes.func.isRequired
    }

    constructor(props) {
        super(props)

        this.state = {
            campus: this.props.campus,
            campuses: this.props.campuses || [],
            gathering: this.props.gathering,
            gatherings: this.props.gatherings || [],
        }

        this.handleCampusChange = this.handleCampusChange.bind(this)
        this.handleGatheringChange = this.handleGatheringChange.bind(this)
        this.onChange = this.onChange.bind(this)
        this.handleError = this.handleError.bind(this)
    }

    handleCampusChange(json) {
        let campus = json['campus']
        let campuses = json['campuses'] || []
        let state = this.state
        if (state.campus != campus || state.campuses != campuses) {
            this.onChange({
                campus: campus,
                campuses: campuses,
                gathering: null,
                gatherings: []
            })
        }
    }

    handleGatheringChange(json) {
        let gathering = json['gathering']
        let gatherings = json['gatherings'] || []
        let state = this.state
        if (state.gathering != gathering || state.gatherings != gatherings) {
            this.onChange({
                campus: state.campus,
                campuses: state.campuses,
                gathering: gathering,
                gatherings: gatherings
            })
        }
    }

    onChange(state) {
        this.props.onChange({
            campus: state.campus,
            campuses: state.campuses,
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
        return (
            <Fragment>
                <SelectCampus
                    community={this.props.community}
                    campus={state.campus}
                    campuses={state.campuses}
                    routes={this.props.routes}
                    disabled={this.props.disabled}
                    onChange={this.handleCampusChange}
                />
                <SelectGathering
                    className={this.props.enableGatherings ? 'd-block' : 'd-none'}
                    community={this.props.community}
                    campus={state.campus}
                    gathering={state.gathering}
                    gatherings={state.gatherings}
                    routes={this.props.routes}
                    disabled={this.props.disabled}
                    onChange={this.handleGatheringChange}
                />
            </Fragment>
        )
    }
}
