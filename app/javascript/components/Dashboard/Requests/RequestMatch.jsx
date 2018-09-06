import React, { Fragment } from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../../BaseComponent'

const DangerBreakpoint = 0.25
const WarningBreakpoint = 0.70

export default class RequestMatch extends BaseComponent {
    static propTypes = {
        id: PropTypes.string.isRequired,
        match: PropTypes.object.isRequired,
        name: PropTypes.string.isRequired
    }

    constructor(props) {
        super(props)
    }

    renderCategories() {
        let props = this.props
        let match = props.match

        if (match.matches.length <= 0) {
            return null
        }

        return match.matches.map(category => {
            let aligned = category.desired <= 0 ? 1 : (category.aligned / category.desired)
            let remainder = category.total - category.desired
            let misaligned = remainder <= 0 ? 0 : (category.misaligned / remainder)
            let tooltip = `<div>Aligned ${aligned.toLocaleString(undefined, { style: 'percent' })}</div><div>Misaligned ${misaligned.toLocaleString(undefined, { style: 'percent' })}</div>`

            let degree = null
            if (aligned < DangerBreakpoint) {
                degree = 'danger'
            }
            else if (aligned < WarningBreakpoint) {
                degree = 'warning'
            }
            else {
                degree = 'success'
            }
            let classes = `small p-1 mr-1 border rounded border-${degree} d-inline-block text-${degree}`

            return (
                <span
                    className={classes}
                    key={`${props.id}-${category.single}`}
                    data-toggle='tooltip'
                    data-placement='top'
                    data-html={true}
                    title={tooltip}
                >
                    {category.plural}
                </span>
            )
        })
    }

    render() {
        let props = this.props
        let gathering = props.match.gathering
        return (
            <label className='d-block mb-1'>
                <div className='row no-gutters'>
                    <div className='col-4'>
                        <input
                            type='radio'
                            name={props.name}
                            value={gathering.id}
                        />&nbsp;
                        {gathering.name}
                    </div>
                    <div className='col-8'>
                        {this.renderCategories()}
                    </div>
                </div>
            </label>
        )
    }
}
