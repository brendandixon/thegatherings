import React from 'react'
import PropTypes from 'prop-types'
import jQuery from 'jquery'

import BaseComponent from '../BaseComponent'
import ClientSideForm from '../Forms/ClientSideForm'
import ButtonInput from '../Forms/ButtonInput'
import { makeRailsId, makeRailsName } from '../Utilities/RailsUtilities'

import SubmitStepButton from './SubmitStepButton'

export default class CategoryForm extends BaseComponent {
    static propTypes = {
        category: PropTypes.object.isRequired,
        onError: PropTypes.func.isRequired,
        onSuccess: PropTypes.func.isRequired
    }

    constructor(props) {
        super(props)
        this.state = { values: [] }
        this.allTag = `__${Date.now().toString()}__`
        this.handleClick = this.handleClick.bind(this)
        this.handleSuccess = this.handleSuccess.bind(this)
    }

    handleClick(event) {
        event.preventDefault()

        let category = this.props.category
        let input = jQuery(`input[type=${category.singleton ? 'radio' : 'checkbox'}]`, event.target)
        let value = input.val()
        let values = this.state.values || []

        if (category.singleton) {
            values = [value]
        } else {
            if (values.find(v => v == value)) {
                values = values.filter(v => v != value)
            } else {
                values.push(value)
            }
        }

        this.setState({ values: values })
    }

    handleSuccess(json) {
        let category = this.props.category
        let allTag = makeRailsName(category.name, this.allTag)
        if (json && json[allTag] == this.allTag) {
            json = {}
            for (let tag of category.tags) {
                json[makeRailsName(category.name, tag.name)] = tag.name
            }
        }

        this.props.onSuccess(json)
    }

    renderTags() {
        let category = this.props.category
        let tags = category.tags

        let columns = []
        let col = category.all_prompt && category.all_prompt.length > 0
            ? -1
            : 0
        for (; col < tags.length; col++) {
            let tag = col < 0
                        ? { name: this.allTag, prompt: category.all_prompt }
                        : tags[col]
            let id = makeRailsId(category.name, tag.name)
            let isChecked = this.state.values.find(v => v == tag.name)
            let name = category.singleton ? category.name : makeRailsName(category.name, tag.name)
            let type = category.singleton ? 'radio' : 'checkbox'

            columns.push(
                <div
                    key={`${category.name}_${col}`}
                    className={`col-3 card border-0 mb-4 mr-2`}
                >
                    <ButtonInput
                        className='card-body'
                        style={{ whiteSpace: 'normal' }}
                        id={id}
                        isChecked={isChecked}
                        name={name}
                        type={type}
                        value={tag.name}
                        onClick={this.handleClick}
                    >
                        {tag.prompt}
                    </ButtonInput>
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
                onSuccess={this.handleSuccess}
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
