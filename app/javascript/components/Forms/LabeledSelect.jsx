import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../BaseComponent'

import Label from './Label'
import Option from './Option'

export default class LabeledSelect extends BaseComponent {
    static propTypes = {
        hasFocus: PropTypes.bool,
        disabled: PropTypes.bool,
        id: PropTypes.string.isRequired,
        label: PropTypes.string.isRequired,
        name: PropTypes.string.isRequired,
        size: PropTypes.number,
        value: PropTypes.string,
        options: PropTypes.arrayOf(
                    PropTypes.shape({
                        value: PropTypes.oneOfType([
                                    PropTypes.number,
                                    PropTypes.string
                                ]).isRequired,
                        label: PropTypes.string.isRequired
                    }).isRequired
                ).isRequired,
        onChange: PropTypes.func
    }

    constructor(props) {
        super(props)
        this._select = null
        this.state = {
            value: this.props.value
        }

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
            this._select.focus()
        }
    }

    handleChange(event) {
        this.setState({
            value: event.target.value
        })

        if (this.props.onChange) {
            let json = {}
            json[this.props.name] = event.target.value
            this.props.onChange(json)
        }
    }

    renderOptions() {
        return this.props.options.map((option, i) => {
            let id = this.props.id + '_' + (i).toString()
            return (
                <Option
                    key={id}
                    id={id}
                    value={option.value}
                    label={option.label}
                />
            )
        });
    }

    render() {
        return (
            <div className='form-group'>
                <Label className='mb-0' for={this.props.id} value={this.props.label} />
                <select
                    id={this.props.id}
                    name={this.props.name}
                    className='form-control custom-select'
                    disabled={this.props.disabled}
                    ref={c => (this._select = c)}
                    size={this.props.size || '1'}
                    value={this.state.value}
                    onChange={this.handleChange}
                >
                    {this.renderOptions()}
                </select>
            </div>
        );
    }
}
