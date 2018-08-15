import React from 'react'
import PropTypes from 'prop-types'
import jQuery from 'jquery'

import BaseComponent from '../BaseComponent'
import ClientSideForm from '../Forms/ClientSideForm'
import SubmitButton from '../Forms/SubmitButton'
import Alert from '../Utilities/Alert'
import fetchTimeout from '../Utilities/FetchTimeout'
import { evaluateResponse, evaluateJSONResponse, readJSONResponse } from '../Utilities/HttpUtilities'
import { errorsToMessages } from '../Utilities/RailsUtilities'

import RegistrationForm from './RegistrationForm'
import SelectForm from './SelectForm'
import CategoryForm from './CategoryForm'
import TimedMessage from './TimedMessage'

export default class SignUp extends BaseComponent {
    static propTypes = {
        community: PropTypes.object,
        campus: PropTypes.object,
        registrationPath: PropTypes.string.isRequired,
        communitiesPath: PropTypes.string,
        completedPath: PropTypes.string,
        skipWelcome: PropTypes.bool,
        onReady: PropTypes.func
    }

    constructor(props) {
        super(props)

        this.state = {
            renderTitle: null,
            renderBody: null,

            phase: 0,
            categoryPhase: 0,
            errors: [],

            member: null,
            communities: [],
            community: this.props.community,
            categories: [],
            communityMembership: null,
            campuses: [],
            campus: this.props.campus,
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
        this.ensureCategories = this.ensureCategories.bind(this)
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
                onSuccess: ((state, json) => {
                    let community = this.props.community || state.communities.find(community => community.id == json.id)
                    return setJson(state, community, 'community')
                })
            },
            {
                name: 'joinCommunity',
                action: this.joinCommunity,
                onSuccess: ((state, json) => setJson(state, json, 'communityMembership'))
            },
            {
                name: 'ensureCategories',
                action: this.ensureCategories,
                onSuccess: ((state, json) => setJson(state, json, 'categories'))
            },
            {
                name: 'ensureCampuses',
                action: this.ensureCampuses,
                onSuccess: ((state, json) => setJson(state, json, 'campuses'))
            },
            {
                name: 'selectCampus',
                action: this.selectCampus,
                onSuccess: ((state, json) => {
                    let campus = this.props.campus || state.campuses.find(campus => campus.id == json.id)
                    return setJson(state, campus, 'campus')
                })
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

                    state.categoryPhase += 1
                    this.setState({ categoryPhase: state.categoryPhase })
                    return (state.categoryPhase >= state.categories.length)
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
        if (this.props.onReady) {
            this.props.onReady(false)
        }

        this.setState({
            categoryPhase: 0,
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

        if (!this.props.community) {
            if (!communities || communities.length == 0) {
                this.setState({
                    communities: [],
                    community: null,
                    categories: []
                })
                campuses = null
            }
            else if (communities.length > 1) {
                this.setState({
                    community: null,
                    categories: []
                })
                campuses = null
            }
        }

        if (!this.props.campus) {
            if (!campuses || campuses.length == 0) {
                this.setState({
                    campuses: [],
                    campus: null
                })
            }
            else if (campuses.length > 1) {
                this.setState({
                    campus: null
                })
            }
        }
    }

    welcome(state) {
        if (this.props.skipWelcome) {
            Promise
                .resolve()
                .then(() => this.handleSuccess(null))
        }
        else {
            this.setState({
                renderTitle: (<span>Sign Up for a Gathering</span>),
                renderBody: (
                    <ClientSideForm
                        key='welcome'
                        onSubmit={this.handleSuccess}
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
    }

    registerMember(state) {
        this.initiateSignUp(state)

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
        let communities = state.communities || []
        let promise = !state.community && communities.length <= 0
            ? fetchTimeout(this.props.communitiesPath, {
                credentials: 'same-origin',
                method: 'GET',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json; charset=utf-8'
                }
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
        let community = state.community || (communities.length == 1 ? communities[0] : null)
        if (community) {
            Promise
                .resolve(community)
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
        let path = `${state.community.memberships_path}?member_id=${state.member.id}`
        fetchTimeout(path, {
            credentials: 'same-origin',
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json; charset=utf-8'
            }
        })
            .then(readJSONResponse)
            .then(evaluateJSONResponse)
            .then(json => this.handleSuccess(json))
            .catch(error => this.handleError(error))
    }

    ensureCategories(state) {
        let categories = state.categories || []
        let promise = categories.length <= 0
            ? fetchTimeout(state.community.categories_path, {
                credentials: 'same-origin',
                method: 'GET',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json; charset=utf-8'
                }
            })
                .then(readJSONResponse)
                .then(evaluateJSONResponse)
            : Promise.resolve(categories)
    
        promise
            .then(json => this.handleSuccess(json))
            .catch(error => this.handleError(error))
    }

    ensureCampuses(state) {
        let campuses = state.campuses || []
        let promise = !state.campus && campuses.length <= 0
            ? fetchTimeout(state.community.campuses_path, {
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
            .then(json => this.handleSuccess(json))
            .catch(error => this.handleError(error))
    }

    selectCampus(state) {
        let campuses = state.campuses
        let campus = state.campus || (campuses.length == 1 ? campuses[0] : null)
        if (campus) {
            Promise
                .resolve(campus)
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
        let path = `${state.campus.memberships_path}?member_id=${state.member.id}`
        fetchTimeout(path, {
            credentials: 'same-origin',
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json; charset=utf-8'
            }
        })
            .then(readJSONResponse)
            .then(evaluateJSONResponse)
            .then(json => this.handleSuccess(json))
            .catch(error => this.handleError(error))
    }

    ensurePreferences(state) {
        let path = `${state.community.preferences_path}?membership_id=${state.communityMembership.id}` 
        fetchTimeout(path, {
            credentials: 'same-origin',
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json; charset=utf-8'
            }
        })
            .then(readJSONResponse)
            .then(evaluateJSONResponse)
            .then(json => this.handleSuccess(json))
            .catch(error => this.handleError(error))
    }

    selectPreferences(state) {
        if (state.categories.length > 0) {
            let category = state.categories[state.categoryPhase]
            this.setState({
                renderTitle: (<span>Select Preferences</span>),
                renderBody: (
                    <CategoryForm
                        key={`selectPreferences_${category.plural}`}
                        category={category}
                        onError={this.handleError}
                        onSuccess={this.handleSuccess}
                    >
                        <p className='lead text-muted pb-2 pt-2'>{category.prompt}</p>
                    </CategoryForm>
                )
            })
        }
    }

    submitPreferences(state) {
        if (state.taggings.length > 0) {
            let taggings = {}

            for (let o of state.taggings) {
                for (let p in o) {
                    let k = p.split('[')
                    let category = k && k.length > 0 ? k[0] : null
                    if (category) {
                        taggings[category] = taggings[category] || []
                        taggings[category].push(o[p])
                    }
                }
            }

            fetchTimeout(state.preferences.set_taggings_path, {
                credentials: 'same-origin',
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
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
        let path = `${state.campus.requests_path}?member_id=${state.member.id}` 
        fetchTimeout(path, {
            credentials: 'same-origin',
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json; charset=utf-8'
            }
        })
            .then(readJSONResponse)
            .then(evaluateJSONResponse)
            .then(json => this.handleSuccess(json))
            .catch(error => this.handleError(error))
    }

    signOutIfNeeded(state) {
        let path = `${state.member.signout_path}?member_id=${state.member.id}`
        fetchTimeout(path, {
            credentials: 'same-origin',
            method: 'DELETE',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json; charset=utf-8'
            }
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
                            Welcome to the
                            <span className='d-block'>
                                <em>{state.campus.name}</em> campus of <em>{state.community.name}</em>
                            </span>
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
        if (this.props.onReady) {
            this.props.onReady(true)
        }

        if (this.props.completedPath && this.props.completedPath.length > 0) {
            window.location.replace(this.props.completedPath)
        }
        else {
            this.setState({
                phase: 0
            })
        }
        return true
    }

    handleError(error) {
        let state = this.state
        state.phase = this._handlers.length - 1

        let handler = this._handlers[state.phase]

        console.log(error)

        if (error.name && error.name == 'HttpRailsError') {
            state.errors = errorsToMessages(error.errors, { base: 'We\u0027re unable to add you as a member' })
        }

        this.setState(state)
        handler.action(state)
    }

    handleSuccess(json) {
        let state = this.state
        let handler = this._handlers[state.phase]

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
