import React from 'react'
import PropTypes from 'prop-types'
import jQuery from 'jquery'

import BaseComponent from '../BaseComponent'
import ClientSideForm from '../Forms/ClientSideForm'
import SubmitButton from '../Forms/SubmitButton'
import Alert from '../Utilities/Alert'
import { evaluateResponse, evaluateJSONResponse, readJSONResponse } from '../Utilities/HttpUtilities'
import { errorsToMessages } from '../Utilities/RailsUtilities'

import RegistrationForm from './RegistrationForm'
import SelectForm from './SelectForm'
import TagSetForm from './TagSetForm'
import TimedMessage from './TimedMessage'

export default class SignUp extends BaseComponent {
    static propTypes = {
        registrationPath: PropTypes.string.isRequired,
        communitiesPath: PropTypes.string.isRequired,
        completedPath: PropTypes.string,
        skipWelcome: PropTypes.bool,
    }

    constructor(props) {
        super(props)
        this.state = {
            renderTitle: null,
            renderBody: null,

            phase: this.props.skipWelcome ? 1 : 0,
            tagSetPhase: 0,
            errors: [],

            member: null,
            communities: null,
            community: null,
            tagSets: null,
            communityMembership: null,
            campuses: null,
            campus: null,
            campusMembership: null,
            preferences: null,
            request: null,
            taggings: []
        }

        this.initiateSignUp = this.initiateSignUp.bind(this)

        this.welcome = this.welcome.bind(this)
        this.registerMember = this.registerMember.bind(this)
        this.ensureCommunities = this.ensureCommunities.bind(this)
        this.selectCommunity = this.selectCommunity.bind(this)
        this.joinCommunity = this.joinCommunity.bind(this)
        this.ensureTagSets = this.ensureTagSets.bind(this)
        this.ensureCampuses = this.ensureCampuses.bind(this)
        this.selectCampus = this.selectCampus.bind(this)
        this.joinCampus = this.joinCampus.bind(this)
        this.ensurePreferences = this.ensurePreferences.bind(this)
        this.selectPreferences = this.selectPreferences.bind(this)
        this.submitPreferences = this.submitPreferences.bind(this)
        this.requestGathering = this.requestGathering.bind(this)
        this.signOutIfNeeded = this.signOutIfNeeded.bind(this)
        this.completeSignUp = this.completeSignUp.bind(this)
        this.incompleteSignUp = this.incompleteSignUp.bind(this)

        this.handleCompletion = this.handleCompletion.bind(this)
        this.handleError = this.handleError.bind(this)
        this.handleSuccess = this.handleSuccess.bind(this)

        const setJson = (state, json, m) => { state[m] = json; this.setState(state); return true; }
        this._handlers = [
            {
                name: 'welcome',
                action: this.welcome,
                onSuccess: null
            },
            {
                name: 'register',
                action: this.registerMember,
                onSuccess: ((state, json) => setJson(state, json, 'member'))
            },
            {
                name: 'ensureCommunities',
                action: this.ensureCommunities,
                onSuccess: ((state, json) => setJson(state, json, 'communities'))
            },
            {
                name: 'selectCommunity',
                action: this.selectCommunity,
                onSuccess: ((state, json) => setJson(state, state.communities.find(community => community.id == json.id), 'community'))
            },
            {
                name: 'joinCommunity',
                action: this.joinCommunity,
                onSuccess: ((state, json) => setJson(state, json, 'communityMembership'))
            },
            {
                name: 'ensureTagSets',
                action: this.ensureTagSets,
                onSuccess: ((state, json) => setJson(state, json, 'tagSets'))
            },
            {
                name: 'ensureCampuses',
                action: this.ensureCampuses,
                onSuccess: ((state, json) => setJson(state, json, 'campuses'))
            },
            {
                name: 'selectCampus',
                action: this.selectCampus,
                onSuccess: ((state, json) => setJson(state, state.campuses.find(campus => campus.id == json.id), 'campus'))
            },
            {
                name: 'joinCampus',
                action: this.joinCampus,
                onSuccess: ((state, json) => setJson(state, json, 'campusMembership'))
            },
            {
                name: 'ensurePreferences',
                action: this.ensurePreferences,
                onSuccess: ((state, json) => {
                    if (json.length && json.length > 0) {
                        json = json[0]
                    }
                    return setJson(state, json, 'preferences')
                })
            },
            {
                name: 'selectPreferences',
                action: this.selectPreferences,
                onSuccess: ((state, json) => {
                    let taggings = state.taggings || []
                    if (!jQuery.isEmptyObject(json)) {
                        taggings.push(json)
                        setJson(state, taggings, 'taggings')
                    }

                    state.tagSetPhase += 1
                    this.setState({ tagSetPhase: state.tagSetPhase })
                    return (state.tagSetPhase >= state.tagSets.length)
                })
            },
            {
                name: 'submitPreferences',
                action: this.submitPreferences,
                onSuccess: null
            },
            {
                name: 'requestGathering',
                action: this.requestGathering,
                onSuccess: ((state, json) => setJson(state, json, 'request'))
            },
            {
                name: 'signOutIfNeeded',
                action: this.signOutIfNeeded,
                onSuccess: null
            },
            {
                name: 'complete',
                action: this.completeSignUp,
                onSuccess: ((state, json) => this.handleCompletion(state))
            },
            {
                name: 'incomplete',
                action: this.incompleteSignUp,
                onSuccess: ((state, json) => this.handleCompletion(state))
            }
        ]
    }

    componentDidMount() {
        let state = this.state
        let handler = this._handlers[state.phase]
        handler.action(state)
    }

    initiateSignUp(state) {
        this.setState({
            phase: 0,
            tagSetPhase: 0,
            errors: [],

            member: null,
            communityMembership: null,
            campusMembership: null,
            preferences: null,
            request: null,
            taggings: []
        })

        let communities = state.communities
        let campuses = state.campuses
        if (!communities || communities.length == 0) {
            this.setState({
                communities: null,
                community: null,
                tagSets: null
            })
            campuses = null
        }
        else if (communities.length > 1) {
            this.setState({
                community: null,
                tagSets: null
            })
            campuses = null
        }

        if (!campuses || campuses.length == 0) {
            this.setState({
                campuses: null,
                campus: null
            })
        }
        else if (campuses.length > 1) {
            this.setState({
                campus: null
            })
        }
    }

    welcome(state) {
        this.setState({
            renderTitle: (<span>Sign Up for a Gathering</span>),
            renderBody: (
                <ClientSideForm
                    key='welcome'
                    onSuccess={this.handleSuccess}
                >
                    <div className='text-center text-muted lead pb-2 pt-2'>
                        <div>Meet. Encourage. Laugh.</div>
                        <div>Worship. Pray. Grow.</div>
                        <div>Find Your Place.</div>
                        <div>Be the Body.</div>
                    </div>
                    <SubmitButton
                        title='Sign Up'
                        position='center'
                    />
                </ClientSideForm>
            )
        })
    }

    registerMember(state) {
        this.setState({
            renderTitle: (<span>Let&apos;s start with the basics&hellip;</span>),
            renderBody: (
                <RegistrationForm
                    action={this.props.registrationPath}
                    excludePassword={true}
                    onError={this.handleError}
                    onSuccess={this.handleSuccess}
                />
            )
        })
    }

    ensureCommunities(state) {
        let communities = state.communities
        let promise = !communities || communities.length <= 0
            ? fetch(this.props.communitiesPath, {
                credentials: 'same-origin',
                method: 'GET'
            })
                .then(readJSONResponse)
                .then(evaluateJSONResponse)
            : Promise.resolve(communities)

        promise
            .then(json => this.handleSuccess(json))
            .catch(error => this.handleError(error))
    }

    selectCommunity(state) {
        let communities = state.communities
        if (communities.length == 1) {
            Promise
                .resolve(communities[0])
                .then(json => this.handleSuccess(json))
                .catch(error => this.handleError(error))
        }

        else {
            this.setState({
                renderTitle: (<span>Which Community is home?</span>),
                renderBody: (
                    <SelectForm
                        options={communities}
                        title='Community Name'
                        onSuccess={this.handleSuccess}
                    />
                )
            })
        }
    }

    joinCommunity(state) {
        fetch(`${state.community.memberships_path}?member_id=${state.member.id}`, {
            credentials: 'same-origin',
            method: 'POST'
        })
            .then(readJSONResponse)
            .then(evaluateJSONResponse)
            .then(json => this.handleSuccess(json))
            .catch(error => this.handleError(error))
    }

    ensureTagSets(state) {
        let tagSets = state.tagSets
        let promise = !tagSets
            ? fetch(state.community.tag_sets_path, {
                credentials: 'same-origin',
                method: 'GET'
                })
                    .then(readJSONResponse)
                    .then(evaluateJSONResponse)
            : Promise.resolve(tagSets)
    
        promise
            .then(json => this.handleSuccess(json))
            .catch(error => this.handleError(error))
    }

    ensureCampuses(state) {
        let campuses = state.campuses
        let promise = !campuses || campuses.length <= 0
            ? fetch(state.community.campuses_path, {
                credentials: 'same-origin',
                method: 'GET'
            })
                .then(readJSONResponse)
                .then(evaluateJSONResponse)
            : Promise.resolve(campuses)

        promise
            .then(json => this.handleSuccess(json))
            .catch(error => this.handleError(error))
    }

    selectCampus(state) {
        let campuses = state.campuses
        if (campuses.length == 1) {
            Promise
                .resolve(campuses[0])
                .then(json => this.handleSuccess(json))
                .catch(error => this.handleError(error))
        }

        else {
            this.setState({
                renderTitle: (<span>Which Campus is yours?</span>),
                renderBody: (
                    <SelectForm
                        options={campuses}
                        title='Campus Name'
                        onSuccess={this.handleSuccess}
                    />
                )
            })
        }
    }

    joinCampus(state) {
        fetch(`${state.campus.memberships_path}?member_id=${state.member.id}`, {
            credentials: 'same-origin',
            method: 'POST'
        })
            .then(readJSONResponse)
            .then(evaluateJSONResponse)
            .then(json => this.handleSuccess(json))
            .catch(error => this.handleError(error))
    }

    ensurePreferences(state) {
        fetch(`${state.community.preferences_path}?member_id=${state.member.id}`, {
            credentials: 'same-origin',
            method: 'POST'
        })
            .then(readJSONResponse)
            .then(evaluateJSONResponse)
            .then(json => this.handleSuccess(json))
            .catch(error => this.handleError(error))
    }

    selectPreferences(state) {
        if (state.tagSets.length > 0) {
            let tagSet = state.tagSets[state.tagSetPhase]
            this.setState({
                renderTitle: (<span>Select Preferences</span>),
                renderBody: (
                    <TagSetForm
                        key={`selectPreferences_${tagSet.plural}`}
                        tagSet={tagSet}
                        onError={this.handleError}
                        onSuccess={this.handleSuccess}
                    >
                        <p className='lead text-muted pb-2 pt-2'>{tagSet.prompt}</p>
                    </TagSetForm>
                )
            })
        }
    }

    submitPreferences(state) {
        if (state.taggings.length > 0) {
            const railsName = /^(\w+)\[(\w+)\]$/
            let taggings = {}

            for (let o of state.taggings) {
                for (let p in o) {
                    let m = railsName.exec(p)
                    if (m && m.length > 1) {
                        let k = m[1]
                        let v = m[2]
                        taggings[k] = taggings[k] || []
                        if (o[p] == 'on') {
                            taggings[k].push(v)
                        }
                    }
                }
            }

            fetch(`${state.preferences.set_taggings_path}`, {
                credentials: 'same-origin',
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=utf-8'
                },
                body: JSON.stringify({taggings: taggings})
            })
                .then(evaluateResponse)
                .then(json => this.handleSuccess(json))
                .catch(error => this.handleError(error))
        }
    }

    requestGathering(state) {
        fetch(`${state.campus.requests_path}?member_id=${state.member.id}`, {
            credentials: 'same-origin',
            method: 'POST'
        })
            .then(readJSONResponse)
            .then(evaluateJSONResponse)
            .then(json => this.handleSuccess(json))
            .catch(error => this.handleError(error))
    }

    signOutIfNeeded(state) {
        fetch(`${state.member.signout_path}?member_id=${state.member.id}`, {
            credentials: 'same-origin',
            method: 'DELETE'
        })
            .then(evaluateResponse)
            .then(json => this.handleSuccess(json))
            .catch(error => this.handleError(error))
    }

    completeSignUp(state) {
        this.setState({
            renderTitle: (<span>Congratulations!</span>),
            renderBody: (
                <TimedMessage
                    key='completeSignUp'
                    submitTitle='Finish'
                    onSuccess={this.handleSuccess}
                >
                    <div className='text-center text-muted pb-2 pt-2'>
                        <p className='lead'>
                            You are now signed up.
                    </p>
                        <p className='lead'>
                            Someone will reach out to you soon to get you connected.
                    </p>
                        <p className='lead'>
                            Thank you!
                    </p>
                    </div>
                </TimedMessage>
            )
        })
    }

    incompleteSignUp(state) {
        let alert = null
        if (state.errors && state.errors.length > 0) {
            alert = (
                <Alert
                    messages={state.errors}
                    category='danger'
                />
            )
        }
        this.setState({
            renderTitle: (<span>We&apos;re Sorry!</span>),
            renderBody: (
                <TimedMessage
                    key='incompleteSignUp'
                    secondsDelay={0}
                    submitTitle='Finish'
                    onSuccess={this.handleSuccess}
                >
                    <div className='text-center text-muted pb-2 pt-2'>
                        {alert || (
                            <p className='lead'>
                                Sadly, something went wrong.
                        </p>
                        )}
                        <p className='lead'>
                            Be assured that someone will be soon digging into this to correct the problem.
                        </p>
                        <p className='lead'>
                            Please stop by and try again in the near future.
                        </p>
                    </div>
                </TimedMessage>
            )
        })
    }

    handleCompletion(state) {
        if (this.props.completedPath && this.props.completedPath.length > 0) {
            window.location.replace(this.props.completedPath)
        }
        else {
            this.initiateSignUp(state)
        }
        return true
    }

    handleError(error) {
        let state = this.state
        state.phase = this._handlers.length - 1

        let handler = this._handlers[state.phase]

        // console.log("ERROR")
        // console.log(error)

        if (error.name && error.name == 'HttpRailsError') {
            state.errors = errorsToMessages(error.errors, { base: 'We\u0027re unable to add you as a member' })
        }

        this.setState(state)
        handler.action(state)
    }

    handleSuccess(json) {
        let state = this.state
        let handler = this._handlers[state.phase]

        // console.log("SUCCESS")
        // console.log(state)

        if (!handler.onSuccess || handler.onSuccess(state, json)) {
            state.phase = handler.name.endsWith('complete')
                ? 0
                : state.phase + 1
            handler = this._handlers[state.phase]
            this.setState({ phase: state.phase })
        }
        
        handler.action(state)
    }

    render() {
        let state = this.state
        if (!state.renderTitle) {
            return state.renderBody
        }
        else {
            return (
                <div className='card'>
                    <div className='card-header display-4 text-muted text-center'>
                        {state.renderTitle}
                    </div>
                    <div className='card-body'>
                        {state.renderBody}
                    </div>
                </div>
            )

        }
    }
}
