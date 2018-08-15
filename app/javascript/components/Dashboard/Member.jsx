import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../BaseComponent'

import Navigation from './Navigation'
import Overview from './Overview/Overview'
import Reports from './Reports/Reports'
import Requests from './Requests/Requests'


const tabs = [
    { value: 'mygatherings', name: 'My Gatherings' }
]

export default class Member extends BaseComponent {
    static propTypes = {
        community: PropTypes.object.isRequired,
        campus: PropTypes.object,
        gathering: PropTypes.object,
        member: PropTypes.object.isRequired,
        routes: PropTypes.object.isRequired,
        tab: PropTypes.oneOf(tabs.map(t => t.value)),
    }

    constructor(props) {
        super(props)

        this.state = {
            activeTab: this.props.tab || 'mygatherings',
            campus: this.props.campus,
            campuses: [],
            gathering: this.props.gathering,
            gatherings: []
        }

        this.handleChange = this.handleChange.bind(this)
        this.handleNavigation = this.handleNavigation.bind(this)
        this.handleError = this.handleError.bind(this)
    }

    handleChange(json) {
        this.setState({
            campus: json['campus'],
            campuses: json['campuses'] || [],
            gathering: json['gathering'],
            gatherings: json['gatherings'] || []
        })
    }

    handleNavigation(json) {
        this.setState({
            activeTab: json['tab']
        })
    }

    handleError(error) {
        console.log(error)
    }

    renderSection() {
        let state = this.state
        switch (state.activeTab) {

            default:
                return (
                    <div className='display-3 text-center text-muted'>{tabs.find(t => t.value == state.activeTab).name}</div>
                )
        }
    }

    render() {
        let state = this.state
        return (
            <div>
                <Navigation
                    id={Date.now().toString()}
                    community={this.props.community}
                    campus={state.campus}
                    gathering={state.gathering}
                    activeTab={state.activeTab}
                    tabs={tabs}
                    member={this.props.member}
                    routes={this.props.routes}
                    onChange={this.handleNavigation}
                />
                <section>
                    {this.renderSection()}
                </section>
            </div>
        )
    }
}
