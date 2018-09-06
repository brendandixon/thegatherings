import React, { Fragment } from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../../BaseComponent'
import { parseRailsDate } from '../../Utilities/RailsUtilities'

export default class RequestsCard extends BaseComponent {
    static propTypes = {
        id: PropTypes.string.isRequired,
        campus: PropTypes.object,
        gathering: PropTypes.object,
        request: PropTypes.object.isRequired,
        onClick: PropTypes.func,
    }

    constructor(props) {
        super(props)

        this.formatDate = this.formatDate.bind(this)
        this.handleClick = this.handleClick.bind(this)
    }

    handleClick() {
        if (this.props.onClick) {
            this.props.onClick(this.props.request)
        }
    }

    formatDate(verb, d) {
        if (!d) {
            return null
        }
        else {
            return `${verb} ${d.fromNow()} (${d.format('l')})`
        }
    }

    renderDates() {
        let request = this.props.request
        let expiresOn = parseRailsDate(request['expires_on'])
        let respondedOn = parseRailsDate(request['responded_on'])
        let sentOn = parseRailsDate(request['sent_on'])
        return (
            <div className='section-dates'>
                <div>{this.formatDate('Received', sentOn)}</div>
                <div>{this.formatDate('Responded', respondedOn)}</div>
                <div>{this.formatDate('Expires', expiresOn)}</div>
            </div>
        )
    }

    renderLocation() {
        let props = this.props
        let request = this.props.request
        return (
            <div className='section'>
                <div className='section-title'>Campus / Gathering</div>
                <div>{request.campus ? request.campus.name : null}</div>
                <div>{request.gathering ? request.gathering.name : null}</div>
            </div>
        )
    }

    renderMember() {
        let request = this.props.request
        let member = request ? request['member'] : null
        return (
            <div className='member'>{member ? `${member.first_name} ${member.last_name}` : null}</div>
        )
    }

    renderOwner() {
        let request = this.props.request
        let owner = request['owner']
        let member = owner ? owner['member'] : null
        return (
            <div className='section'>
                <div className='section-title'>Owner</div>
                { member
                    ? (
                        <div>{`${member['first_name']} ${member['last_name']}`}</div>
                    )
                    : (
                        <div className='text-danger'>Unassigned</div>
                    )
                }
            </div>
        )
    }

    render() {
        return (
            <div
                className='card p-0 mb-2'
                onClick={this.handleClick}
            >
                <div className='card-body p-0 text-muted request'>
                    <div className='details'>
                        <div className={this.props.request.status}>
                            {this.renderMember()}
                            {this.renderLocation()}
                            {this.renderOwner()}
                            {this.renderDates()}
                        </div>
                    </div>
                </div>
            </div>
        )
    }
}
