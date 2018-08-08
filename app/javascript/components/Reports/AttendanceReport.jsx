import React, { Fragment } from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../BaseComponent'
import Attendance from '../Charts/Attendance'

export default class AttendanceReport extends BaseComponent {
    static propTypes = {
        campus: PropTypes.object,
        gathering: PropTypes.object,
        reportsPath: PropTypes.string.isRequired,
        onReady: PropTypes.func
    }

    constructor(props) {
        super(props)
        this.handleSuccess = this.handleSuccess.bind(this)
    }

    handleSuccess(json) {
        if (this.props.onReady) {
            this.props.onReady()
        }
    }

    render() {
        let group = this.props.gathering
                        ? this.props.gathering.name
                        : this.props.campus
                            ? this.props.campus.name
                            : 'All Campuses'

        let queryString = null
        if (this.props.gathering) {
            queryString = `gathering_id=${this.props.gathering.id}`
        } else if (this.props.campus) {
            queryString = `campus_id=${this.props.campus.id}`
        }

        return (
            <Fragment>
                <div className='pt-4 display-4 text-muted text-center'>
                    Attendance Report &mdash; {group}
                </div>
                <Attendance
                    className='pt-2'
                    reportsPath={this.props.reportsPath}
                    queryString={queryString}
                    onSuccess={this.handleSuccess}
                />
            </Fragment>
        )
    }
}
