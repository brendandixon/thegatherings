import React, { Fragment } from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../../BaseComponent'
import Attendance from '../../Charts/Attendance'

export default class AttendanceReport extends BaseComponent {
    static propTypes = {
        id: PropTypes.string.isRequired,
        campus: PropTypes.object,
        gathering: PropTypes.object,
        reportsPath: PropTypes.string.isRequired,
        onReady: PropTypes.func
    }

    constructor(props) {
        super(props)
        this.handleError = this.handleError.bind(this)
        this.handleReady = this.handleReady.bind(this)
    }

    handleError(error) {
        if (this.props.onReady) {
            this.props.onReady(this.props.id, true)
        }
    }

    handleReady(isReady) {
        if (this.props.onReady) {
            this.props.onReady(this.props.id, isReady)
        }
    }

    render() {
        console.log(this.props)
        let group = this.props.gathering
                        ? this.props.gathering.name
                        : this.props.campus
                            ? this.props.campus.name
                            : 'All Campuses'

        let queryString = []
        if (this.props.campus) {
            queryString.push(`campus_id=${this.props.campus.id}`)
        }
        if (this.props.gathering) {
            queryString.push(`gathering_id=${this.props.gathering.id}`)
        }

        return (
            <Fragment>
                <div className='pt-4 display-4 text-muted text-center'>
                    Attendance Report &mdash; {group}
                </div>
                <Attendance
                    className='pt-2'
                    reportsPath={this.props.reportsPath}
                    queryString={queryString.join('&')}
                    onError={this.handleError}
                    onReady={this.handleReady}
                />
            </Fragment>
        )
    }
}
