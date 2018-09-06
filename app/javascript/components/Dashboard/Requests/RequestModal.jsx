import React, { Fragment } from 'react'
import PropTypes from 'prop-types'
import jQuery from 'jquery'

import BaseComponent from '../../BaseComponent'
import { toInteger } from '../../Utilities/Core'
import fetchTimeout from '../../Utilities/FetchTimeout'
import { evaluateJSONResponse, readJSONResponse } from '../../Utilities/HttpUtilities'
import { parseRailsDate, retrieveCSPNonce } from '../../Utilities/RailsUtilities'

import RequestMatch from './RequestMatch'

export default class RequestsModal extends BaseComponent {
    static propTypes = {
        id: PropTypes.string.isRequired,
        request: PropTypes.object,
        show: PropTypes.bool,
        onClose: PropTypes.func,
        onSave: PropTypes.func
    }

    constructor(props) {
        super(props)

        this._modal = null

        this.state = {
            backdropId: `backdrop-${this.props.id}`,
            matches: []
        }

        this.ensureMatches = this.ensureMatches.bind(this)
        this.ensureTooltips = this.ensureTooltips.bind(this)
        this.ensureVisibility = this.ensureVisibility.bind(this)
        this.formatDate = this.formatDate.bind(this)
        this.handleClose = this.handleClose.bind(this)
        this.handleError = this.handleError.bind(this)
        this.handleSave = this.handleSave.bind(this)
        this.renderDates = this.renderDates.bind(this)
        this.renderBody = this.renderBody.bind(this)
        this.renderFooter = this.renderFooter.bind(this)
        this.renderMatches = this.renderMatches.bind(this)
        this.renderHeader = this.renderHeader.bind(this)
        this.renderLocation = this.renderLocation.bind(this)
        this.renderOwner = this.renderOwner.bind(this)
    }

    componentDidMount() {
        this.ensureMatches()
    }

    componentDidUpdate(prevProps, prevState) {
        if (this.props.request != prevProps.request) {
            let request = this.props.request
            let requestId = request ? request.id : ''
            this.setState({
                backdropId: `backdrop-${this.props.id}`,
                matches: []
            })
            this.ensureMatches()
        }
        this.ensureVisibility()
    }

    ensureMatches() {
        let request = this.props.request
        if (!request) {
            return null
        }

        fetchTimeout(request['matches_path'], {
            credentials: 'same-origin',
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json; charset=utf-8'
            }
        })
            .then(readJSONResponse)
            .then(evaluateJSONResponse)
            .then(json => this.setState({ matches: json }))
            .catch(error => this.handleError(error))
    }

    ensureTooltips() {
        let id = Date.now().toString()
        let script = document.createElement('script')
        script.id = id
        script.nonce = retrieveCSPNonce()
        script.type = 'text/javascript'
        script.async = true
        script.innerText = `jQuery('[data-toggle= "tooltip"]').tooltip(); document.getElementById("${id}").remove();`
        this._modal.appendChild(script)
    }

    ensureVisibility() {
        const classes = 'show d-block'

        let body = jQuery('body')
        let backdrop = jQuery(`#${this.state.backdropId}`)
        let modal = jQuery(`#${this.props.id}`)
        if (this.props.show) {
            body.addClass('modal-open')
            backdrop.addClass(classes)
            modal.addClass(classes)
            setTimeout(this.ensureTooltips, 0)
        }
        else {
            body.removeClass('modal-open')
            backdrop.removeClass(classes)
            modal.removeClass(classes)
        }
    }

    formatDate(d) {
        return (
            d
                ? `${d.fromNow()} (${d.format('l')})`
                : null
        )
    }

    handleClose() {
        if (this.props.onClose) {
            this.props.onClose(this.props.request)
        }
    }

    handleError(error) {
        console.log(`ERROR - ${JSON.stringify(error)}`)
    }

    handleSave() {
        if (this.props.onSave) {
            this.props.onSave(this.props.request)
        }
    }

    renderDates() {
        let request = this.props.request
        let expiresOn = request ? parseRailsDate(request['expires_on']) : null
        let respondedOn = request ? parseRailsDate(request['responded_on']) : null
        let sentOn = request ? parseRailsDate(request['sent_on']) : null
        return (
            <Fragment>
                <div className='col-4'>
                    <div className='small'>Received</div>
                    <div className='small'>{sentOn ? this.formatDate(sentOn) : null}</div>
                </div>
                <div className='col-4'>
                    <div className='small'>Last Response</div>
                    { respondedOn
                        ? (
                            <div className='small'>{this.formatDate(respondedOn)}</div>
                        )
                        : (
                            <div className='small text-danger'>Not responded</div>
                        )
                    }
                    
                </div>
                <div className='col-4'>
                    <div className='small'>Expires</div>
                    <div className='small'>{expiresOn ? this.formatDate(expiresOn) : null}</div>
                </div>
            </Fragment>
        )
    }

    renderBody() {
        return (
            <div className='modal-body'>
                <div className='container'>
                    <div className='row justify-content-left pb-2'>
                        {this.renderLocation()}
                    </div>
                    <div className='row justify-content-left pb-2'>
                        {this.renderOwner()}
                    </div>
                    <div className='row justify-content-left pb-2'>
                        {this.renderDates()}
                    </div>
                </div>
            </div>
        )
    }

    renderFooter() {
        return (
            <div className='modal-footer'>
                <button
                    type='button'
                    className='btn btn-outline-secondary'
                    onClick={this.handleClose}
                >
                    Close
                </button>
                <button
                    type='button'
                    className='btn btn-outline-primary'
                    onClick={this.handleSave}
                >
                    Save
                </button>
            </div>
        )
    }

    renderMatches() {
        let request = this.props.request
        let state = this.state
        if (!request || state.matches.length <= 0) {
            return null
        }

        let matches = state.matches.map((match, i) => {
            let name = `request-gathering-${request.id}`
            let key = `request-gathering-${request.id}-${match.gathering.id}`
            return (
                <RequestMatch
                    id={`${name}-${i}`}
                    name={name}
                    key={key}
                    match={match}
                />
            )
        })

        return (
            <div className='modal-body border-top border-color-200'>
                <div className='container'>
                    <div className='row justify-content-left'>
                        <div className='col-12'>
                            <div className='small pb-1'>Possible Gatherings</div>
                            {matches}
                        </div>
                    </div>
                </div>
            </div>
        )
    }

    renderHeader() {
        let request = this.props.request
        let member = request ? request.member : null
        return (
            <div
                className='modal-header'
            >
                <div>
                    <div className='small'>Member</div>
                    <div className='h5 modal-title'>
                        {member
                            ? `${member.first_name} ${member.last_name}`
                            : null
                        }
                    </div>
                </div>
                <button
                    type='button'
                    className='close'
                    onClick={this.handleClose}
                >
                    <span>&times;</span>
                </button>
            </div>
        )
    }

    renderLocation() {
        let request = this.props.request
        return (
            <Fragment>
                <div className='col-5'>
                    <div className='small'>Campus</div>
                    <div>{request && request.campus ? request.campus.name : null}</div>
                </div>
                <div className='col-5'>
                    <div className='small'>Requested Gathering</div>
                    <div>{request && request.gathering ? request.gathering.name : null}</div>
                </div>
            </Fragment>
        )
    }

    renderOwner() {
        let request = this.props.request
        let owner = request ? request.owner : null
        let member = owner ? owner.member : null
        return (
            <div className='col-10'>
                <div className='small'>Owner</div>
                {member
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
        let props = this.props
        let state = this.state
        return (
            <Fragment>
                <div
                    id={state.backdropId}
                    className='modal-backdrop fade d-none'
                    ref={c => this._backdrop = c}
                />
                <div
                    id={props.id}
                    className='modal fade d-none'
                    ref={c => this._modal = c}
                >
                    <div
                        className='modal-dialog modal-lg p-4'
                    >
                        <div
                            className='modal-content text-muted'
                        >
                            {this.renderHeader()}
                            {this.renderBody()}
                            {this.renderMatches()}
                            {this.renderFooter()}
                        </div>
                    </div>
                </div>
                {this.ensureVisibility()}
            </Fragment>
        )
    }
}
