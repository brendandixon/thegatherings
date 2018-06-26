import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../BaseComponent'
import Alert from '../Utilities/Alert'

import BaseForm from './BaseForm'
import LabeledCheckBox from './LabeledCheckBox'
import LabeledInput from './LabeledInput'
import SubmitButton from './SubmitButton'

export default class SignInForm extends BaseComponent {
    static propTypes = {
        action: PropTypes.string.isRequired,
        email: PropTypes.string,
        alerts: PropTypes.arrayOf(PropTypes.string)
    }

    constructor(props) {
        super(props)
    }

    render() {
        return (
            <BaseForm
                action={this.props.action}
                method='post'
            >
                <Alert
                    messages={this.props.alerts}
                    category='danger'
                />
                <LabeledInput
                    label='Email'
                    name={'member[email]'}
                    id={'member_email'}
                    hasFocus={true}
                    type='email'
                    value={this.props.email} />
                <LabeledInput
                    label='Password'
                    name={'member[password]'}
                    id={'member_password'}
                    type='password' />
                <LabeledCheckBox
                    label='Remember Me?'
                    name={'member[remember_me]'}
                    id={'member_remember_me'}
                    isChecked={true} />
                <SubmitButton title='Sign In' position='full' />
            </BaseForm>
        );
    }
}
