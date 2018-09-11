import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../../BaseComponent'

import DataCard from '../DataCard'

export default class AttendeesCard extends BaseComponent {
    static propTypes = {
        id: PropTypes.string.isRequired,
        community: PropTypes.object,
        campus: PropTypes.object,
        gathering: PropTypes.object,
        onReady: PropTypes.func
    }

    constructor(props) {
        super(props)

        this.state = {
            attendees: null,
            average: null
        }

        this.handleReceive = this.handleReceive.bind(this)
    }

    handleReceive(json) {
        json = json || {}
        this.setState({
            attendees: json['attendees'],
            average: json['average']
        })
    }

    render() {
        let state = this.state
        let path = (this.props.campus || this.props.community || {})['attendees_path']
        return (
            <DataCard
                id={this.props.id}
                campus={this.props.campus}
                gathering={this.props.gathering}
                path={path}
                title='Attendees'
                onReceive={this.handleReceive}
                onReady={this.props.onReady}
            >
                <div className='display-6 text-muted'>
                    <div>{state.attendees} Total</div> 
                    <div>{state.average} on Average</div> 
                </div>
            </DataCard>
        )
    }
}
