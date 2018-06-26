import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../BaseComponent'

import ClientSideForm from '../Forms/ClientSideForm'
import LabeledSelect from '../Forms/LabeledSelect'

import SubmitStepButton from './SubmitStepButton'

export default class SelectForm extends BaseComponent {
    static propTypes = {
        options: PropTypes.arrayOf(PropTypes.shape({
                        id: PropTypes.number.isRequired,
                        name: PropTypes.string.isRequired
                    })).isRequired,
        title: PropTypes.string.isRequired,
        onSuccess: PropTypes.func.isRequired
    }

    constructor(props) {
        super(props)
        this.id = Date.now().toString()
        this.handleSuccess = this.handleSuccess.bind(this)
    }

    handleSuccess(json) {
        if (json[this.id]) {
            this.props.onSuccess({id: parseInt(json[this.id])})
        }
    }

    render() {
        let options = this.props.options.map(c => {
            return { value: c.id, label: c.name }
        })
        return (
            <ClientSideForm
                onSuccess={this.handleSuccess}
            >
                <div className='row'>
                    <div className='col-12'>
                        <LabeledSelect
                            hasFocus={true}
                            id={this.id}
                            name={this.id}
                            label={this.props.title}
                            size={4}
                            options={options}
                        />
                    </div>
                </div>
                <SubmitStepButton />
            </ClientSideForm>
        )
    }
}
