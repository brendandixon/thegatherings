import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../BaseComponent'
import Alert from '../Utilities/Alert'
import { errorsToMessages } from '../Utilities/RailsUtilities'

import JsonForm from '../Forms/JsonForm'
import ButtonRadioGroup from '../Forms/ButtonRadioGroup'
import LabeledInput from '../Forms/LabeledInput'

import SubmitStepButton from './SubmitStepButton'

export default class RegistrationForm extends BaseComponent {
    static propTypes = {
        action: PropTypes.string.isRequired,
        excludePassword: PropTypes.bool,
        member: PropTypes.shape({
                first_name: PropTypes.string,
                last_name: PropTypes.string,
                email: PropTypes.string,
                phone: PropTypes.string,
                gender: PropTypes.oneOf(['male', 'female'])
            }),
        onError: PropTypes.func.isRequired,
        onSuccess: PropTypes.func.isRequired
    }

    constructor(props) {
        super(props)
        this.state = {
            messages: [],
            member: this.props.member || {},
            lastErrorAt: Date.now()
        }
        this.genders = [
                            {
                                value: 'male',
                                label: 'Male',
                            },
                            {
                                value: 'female',
                                label: 'Female',
                            }
                        ]
        this.handleError = this.handleError.bind(this)
    }

    handleError(error) {
        if (error.name != 'HttpRailsError') {
            this.props.onError({ errors: { base: 'We\u0027re unable to add you as a member' }})
        }
        else {
            this.setState({
                messages: errorsToMessages(error.errors),
                lastErrorAt: Date.now()
            })
        }
    }

    renderPassword() {
        if (!this.props.excludePassword) {
            return (
                <div className='row'>
                    <div className='col-6'>
                        <LabeledInput
                            label='Password'
                            name='member[password]'
                            id='member_password'
                            type='password'
                        />
                    </div>
                    <div className='col-6'>
                        <LabeledInput
                            label='Confirm Password'
                            name='member[password_confirmation]'
                            id='member_password_confirmation'
                            type='password'
                        />
                    </div>
                </div>
            )
        }
    }

    render() {
        return (
            <JsonForm
                action={this.props.action}
                method='post'
                onSuccess={this.props.onSuccess}
                onError={this.handleError}
            >
                <Alert
                    key={this.state.lastErrorAt}
                    messages={this.state.messages}
                    category='danger'
                />
                <div className='container'>
                    <div className='row'>
                        <div className='col-4'>
                            <LabeledInput
                                label='First Name'
                                name='member[first_name]'
                                id='member_first_name'
                                hasFocus={true}
                                type='text'
                                value={this.state.member.first_name}
                            />
                        </div>
                        <div className='col-5'>
                            <LabeledInput
                                label='Last Name'
                                name='member[last_name]'
                                id='member_last_name'
                                type='text'
                                value={this.state.member.last_name}
                            />
                        </div>
                        <div className='col-3'>
                            <ButtonRadioGroup
                                label='Gender'
                                name='member[gender]'
                                id='member_gender'
                                value={this.state.member.gender}
                                options={this.genders}
                            />
                        </div>
                    </div>
                    <div className='row'>
                        <div className='col-7'>
                            <LabeledInput
                                label='Email'
                                name='member[email]'
                                id='member_email'
                                type='email'
                                value={this.state.member.email}
                            />
                        </div>
                        <div className='col-5'>
                            <LabeledInput
                                label='Phone'
                                name='member[phone]'
                                id='member_phone'
                                type='phone'
                                value={this.state.member.phone}
                            />
                        </div>
                    </div>
                    {this.renderPassword()}
                </div>
                <SubmitStepButton  />
            </JsonForm>
        );
    }
}
