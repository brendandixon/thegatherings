import React from 'react'
import PropTypes from 'prop-types'
import BaseComponent from '../BaseComponent'
import Label from './Label'

export default class LabeledCheckBox extends BaseComponent {
    static propTypes = {
        id: PropTypes.string.isRequired,
        isChecked: PropTypes.bool,
        label: PropTypes.string.isRequired,
        name: PropTypes.string.isRequired
    }

    constructor(props) {
        super(props)
        this._input = null
        this.state = { isChecked: this.props.isChecked || false}
        this.handleChange = this.handleChange.bind(this)
    }

    componentDidUpdate(prevProps, prevState) {
        this.ensureFocus()
    }

    componentDidMount() {
        this.ensureFocus()
    }

    ensureFocus() {
        if (this.props.hasFocus) {
            this._input.focus()
        }
    }

    handleChange(event) {
        this.setState({ isChecked: event.target.checked })
    }

    render() {
        return (
            <div className='form-group form-check'>
                <input name={this.props.name} type='hidden' value='0' />
                <input
                    defaultChecked={this.state.isChecked}
                    className='mr-1 text-muted form-check-input'
                    id={this.props.id}
                    name={this.props.name}
                    type='checkbox'
                    onChange={this.handleChange}
                />
                <Label
                    className='text-muted form-check-label'
                    for={this.props.name} value={this.props.label}
                />
            </div>
        );
    }
}
