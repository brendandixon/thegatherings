import React, { Fragment } from 'react'
import PropTypes from 'prop-types'
import jQuery from 'jquery'

import BaseComponent from '../BaseComponent'

export default class Navigation extends BaseComponent {
    static propTypes = {
        id: PropTypes.string.isRequired,
        community: PropTypes.object.isRequired,
        campus: PropTypes.object,
        gathering: PropTypes.object,
        activeTab: PropTypes.string,
        tabs: PropTypes.arrayOf(PropTypes.object).isRequired,
        routes: PropTypes.object.isRequired,
        member: PropTypes.object.isRequired,
        onChange: PropTypes.func
    }

    constructor(props) {
        super(props)

        this.state = {
            activeTab: this.props.activeTab || this.props.tabs.first.value
        }

        this.handleClick = this.handleClick.bind(this)
        this.handleError = this.handleError.bind(this)
    }

    handleClick(event) {
        event.preventDefault()
        let state = this.state
        let tab = jQuery(event.target).attr('data-tab')
        if (state.activeTab != tab) {
            state.activeTab = tab
            if (this.props.onChange) {
                this.props.onChange({ tab: tab})
            }
            this.setState(state)
        }
    }

    handleError(error) {
        console.log(error)
    }

    renderAccount() {
        let adminPath = this.props.routes.admin_mode_path
            ? (
                <a className='dropdown-item' href={this.props.routes.admin_mode_path} target='_self'>Admin</a>
            )
            : null
        let gatheringPath = this.props.routes.gathering_mode_path
            ? (
                <a className='dropdown-item' href={this.props.routes.gathering_mode_path} target='_self'>Gatherings</a>
            )
            : null
        return (
            <ul className='navbar-nav ml-auto'>
                <li
                    className='nav-item dropdown'>
                    <a className='nav-link dropdown-toggle' href='#' role='button' data-toggle='dropdown' id='navbarAccount'>
                        {`${this.props.member.first_name} ${this.props.member.last_name}`}
                    </a>
                    <div className='dropdown-menu'>
                        <a className='dropdown-item' href={this.props.routes.member_mode_path} target='_self'>Account</a>
                        {adminPath}
                        {gatheringPath}
                        <a className='dropdown-item' href={this.props.member['signout_path']} data-method='delete'>Sign Out</a>
                    </div>
                </li>
            </ul>
        )
    }

    renderTabs() {
        let state = this.state
        let tabs = this.props.tabs.map((tab) => {
            return (
                <li
                    key={tab.value}
                    className={`nav-item ${tab.value == state.activeTab ? 'active' : ''}`}
                >
                    <a
                        href='#'
                        data-tab={tab.value}
                        className='nav-link'
                        onClick={this.handleClick}
                    >
                        {tab.name}
                    </a>
                </li>
            )
        })

        return (
            <ul
                className='navbar-nav mr-auto'
            >
                {tabs}
            </ul>
        )
    }

    renderLogo() {
        return (
            <Fragment>
                <a className='navbar-brand p-0' href='#'>
                    <img
                        className='mr-2 align-top'
                        src={this.props.routes.logo_path}
                        height='55'
                    />
                    <div
                        className='d-inline-block lead'
                        style={{ fontSize: '0.85rem' }}
                    >
                        <div>{this.props.community.name}</div>
                        <div>{this.props.campus ? this.props.campus.name : null}</div>
                    </div>
                </a>
                <button
                    className='navbar-toggler'
                    type='button'
                    data-toggle='collapse'
                    data-target='navbarMain'
                />
            </Fragment>
         )
    }

    render() {
        let state = this.state
        return (
            <div
                className='nav navbar navbar-expand-lg navbar-dark bg-gradient-primary'
            >
                {this.renderLogo()}
                <div
                    className='navbar-collapse collapse'
                    id='#navbarMain'
                >
                    {this.renderTabs()}
                    {this.renderAccount()}
                </div>
            </div>
        )
    }
}
