import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../BaseComponent'
import ClientSideForm from '../Forms/ClientSideForm'
import ButtonBox from '../Forms/ButtonBox'

import SubmitStepButton from './SubmitStepButton'

export default class TagSetForm extends BaseComponent {
    static propTypes = {
        tagSet: PropTypes.object.isRequired,
        onError: PropTypes.func.isRequired,
        onSuccess: PropTypes.func.isRequired
    }

    constructor(props) {
        super(props)
    }

    renderTags() {
        let tagSet = this.props.tagSet
        let tags = tagSet.tags
        let columns = []
        for (let col=0; col < tags.length; col++) {
            let tag = tags[col]
            columns.push(
                <div
                    key={`${tagSet.name}_${col}`}
                    className={`col-3 card border-0 mb-4 mr-2`}
                >
                    <ButtonBox
                        className='card-body'
                        style={{whiteSpace: 'normal'}}
                        id={`${tagSet.name}_${tag.name}`}
                        name={`${tagSet.name}[${tag.name}]`}
                    >
                        {tag.prompt}
                    </ButtonBox>
                </div>
            )
        }
        return (
            <div className='container'>
                <div className='row justify-content-center'>
                    {columns}
                </div>
            </div>
        )
    }

    render() {
        return (
            <ClientSideForm
                onSuccess={this.props.onSuccess}
            >
                {this.props.children}
                {this.renderTags()}
                <SubmitStepButton
                    title={this.props.submitTitle || 'Continue\u2026'}
                    position='right'
                />
            </ClientSideForm>
        )
    }
}
