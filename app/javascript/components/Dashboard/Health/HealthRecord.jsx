import React, { Fragment } from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../../BaseComponent'

const DangerBreakpoint = 20
const WarningBreakpoint = 65

export default class HealthRecord extends BaseComponent {
    static propTypes = {
        healthRecord: PropTypes.object.isRequired
    }

    constructor(props) {
        super(props)

        this.scoreToClasses = this.scoreToClasses.bind(this)
    }

    scoreToClasses(score) {
        let degree = score < DangerBreakpoint
            ? 'danger'
            : score < WarningBreakpoint
                ? 'warning'
                : 'success'
        return `p-1 border rounded border-${degree} d-inline-block text-${degree}`
    }

    renderScores() {
        let healthRecord = this.props.healthRecord
        return (
            <Fragment>
                <div className='col-6'>
                    <div className='row'>
                        <div className='col-3 text-left'><span className={this.scoreToClasses(healthRecord.gather_score)}>Gather &mdash; {healthRecord.gather_score}</span></div>
                        <div className='col-3 text-left'><span className={this.scoreToClasses(healthRecord.adopt_score)}>Adopt &mdash; {healthRecord.adopt_score}</span></div>
                        <div className='col-3 text-left'><span className={this.scoreToClasses(healthRecord.shape_score)}>Shape &mdash; {healthRecord.shape_score}</span></div>
                        <div className='col-3 text-left'><span className={this.scoreToClasses(healthRecord.reflect_score)}>Reflect &mdash; {healthRecord.reflect_score}</span></div>
                    </div>
                </div>
                <div className='col-3 text-right'>
                    <span className={this.scoreToClasses(healthRecord.total_score)}>Total &mdash; {healthRecord.total_score}</span>
                </div>
            </Fragment>
        )
    }

    render() {
        let props = this.props
        let gathering = props.healthRecord.gathering
        return (
            <div className='container'>
                <div className='row'>
                    <div className='col-3 text-muted'>
                        {gathering.name}
                    </div>
                    {this.renderScores()}
                </div>
            </div>
        )
    }
}
