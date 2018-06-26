import React from 'react'
import PropTypes from 'prop-types'
import BaseComponent from '../BaseComponent'
import Label from './Label';

export default class LabeledRadio extends BaseComponent {
    static propTypes = {
        id: PropTypes.string.isRequired,
        label: PropTypes.string.isRequired,
        value: PropTypes.string,
        options: PropTypes.arrayOf(
                    PropTypes.shape({
                        value: PropTypes.string.isRequired,
                        label: PropTypes.string.isRequired
                    }).isRequired
                ).isRequired,
        name: PropTypes.string.isRequired
    }

    constructor(props) {
        super(props)
        this._input = null
        this.state = {value: this.props.value}
        this.reIndex = /^.*_(\d+)$/
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
        this.setState({ value: event.target.value })
    }

    renderOptions() {
        const options = this.props.options.map((option, i) => {
            let id = this.props.id + '_' + (i).toString()
            let isChecked = (option.value == this.state.value)
            return (
                <div key={id} className='form-check form-check-inline' id={this.props.id}>
                    <input
                        className='form-check-input text-muted'
                        type='radio'
                        name={this.props.name}
                        id={id}
                        value={option.value}
                        checked={isChecked}
                        ref={c => (this._input = isChecked ? c : this._input)}
                        onChange={this.handleChange}
                    />
                    <label className='form-check-label text-muted small' htmlFor={this.props.id}>{option.label}</label>
                </div>
            )
        });
        return options
    }

    render() {
        if (this.props.options && this.props.options.length > 0) {
            return (
                <div className='form-group'>
                    <Label className='mb-0 text-muted' for={this.props.id} value={this.props.label} />
                    {this.renderOptions()}
                </div>
            );
        }
        else {
            return ''
        }
    }
}
