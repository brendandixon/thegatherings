import React, { Fragment } from 'react'
import PropTypes from 'prop-types'
import jQuery from 'jquery'

import BaseComponent from '../../BaseComponent'
import Gap from '../../Charts/Gap'
import fetchTimeout from '../../Utilities/FetchTimeout'
import { evaluateJSONResponse, readJSONResponse } from '../../Utilities/HttpUtilities'

export default class GapReport extends BaseComponent {
    static propTypes = {
        id: PropTypes.string.isRequired,
        community: PropTypes.object.isRequired,
        campus: PropTypes.object,
        reportsPath: PropTypes.string.isRequired,
        onReady: PropTypes.func
    }

    constructor(props) {
        super(props)
        this.state = {
            activeTab: 0,
            categories: []
        }

        this.ensureCategories = this.ensureCategories.bind(this)
        this.handleError = this.handleError.bind(this)
        this.handleReady = this.handleReady.bind(this)
        this.handleTab = this.handleTab.bind(this)
    }

    componentDidMount() {
        this.ensureCategories()
    }

    ensureCategories() {
        fetchTimeout(this.props.community.categories_path, {
            credentials: 'same-origin',
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json; charset=utf-8'
            }
        })
            .then(readJSONResponse)
            .then(evaluateJSONResponse)
            .then(json => this.setState({ categories: json }))
            .catch(error => this.handleError(error))
    }

    handleError(error) {
        console.log(error)
        if (this.props.onReady) {
            this.props.onReady(this.props.id, true)
        }
    }

    handleReady(isReady) {
        if (this.props.onReady) {
            this.props.onReady(this.props.id, isReady)
        }
    }

    handleTab(event) {
        event.preventDefault()
        let activeTab = parseInt(jQuery(event.target).attr('data-tab'))
        if (activeTab == NaN) {
            activeTab = 0
        }
        this.setState({
            activeTab: activeTab
        })
    }

    renderTabs(state) {
        return state.categories.map((category, i) => {
            return (
                <li className='nav-item' key={`tab-${category.name}`}>
                    <a
                        className={`nav-link${ i == state.activeTab ? ' active' : ''}`}
                        href={`#pane-${category.name}`}
                        data-tab={i}
                        onClick={this.handleTab}
                        >
                        {category.plural}
                        </a>
                </li>
            )
        })
    }

    renderPanes(state, queryString) {
        return state.categories.map((category, i) => {
            let id = `pane-${category.name}`
            let classes = `border border-top-0 border-gray-300 tab-pane fade${i == state.activeTab ? ' show active' : ''}`
            let categoryQuery = queryString && queryString.length > 0
                ? `${queryString}&categories=${category.name}`
                : `categories=${category.name}`
            return (
                <div
                    className={classes}
                    id={id}
                    key={id}>
                    <Gap
                        reportsPath={this.props.reportsPath}
                        queryString={categoryQuery}
                        onError={this.handleError}
                        onReady={this.handleReady}
                    />
                </div>
            )
        })
    }

    renderGaps() {
        let state = this.state
        let queryString = this.props.campus
                            ? `campus_id=${this.props.campus.id}`
                            : null
        return (
            <Fragment>
                <ul className='nav nav-tabs pt-2'>
                    {this.renderTabs(state)}
                </ul>
                <div className='tab-content'>
                    {this.renderPanes(state, queryString)}
                </div>
            </Fragment>
        )
    }

    render() {
        let group = this.props.campus
                        ? this.props.campus.name
                        : 'All Campuses'
        return (
            <Fragment>
                <div className='pt-4 display-4 text-muted text-center'>
                    Gap Report &mdash; {group}
                </div>
                {this.renderGaps()}
            </Fragment>
        )
    }
}
