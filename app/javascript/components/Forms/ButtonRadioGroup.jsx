import React, { Fragment } from 'react'
import PropTypes from 'prop-types'
import BaseComponent from '../BaseComponent'
import Label from './Label';

export default class ButtonRadioGroup extends BaseComponent {
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
        name: PropTypes.string.isRequired,
        orientation: PropTypes.oneOf(['horizontal', 'vertical']),
        onChange: PropTypes.func
    }

    constructor(props) {
        super(props)
        this._input = null
        this.state = { value: this.props.value }
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

    checkedClass(isChecked) {
        return isChecked
            ? 'btn-primary'
            : 'btn-outline-secondary'
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
        const options = this.props.options.map((option, i) => {
            let id = this.props.id + '_' + (i).toString()
            let isChecked = (option.value == this.state.value)
            return (
                <label className={`btn ${this.checkedClass(isChecked)}`} key={id}>
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
                    {option.label}
                </label>
            )
        });
        return options
    }

    render() {
        if (this.props.options && this.props.options.length > 0) {
            let classes = (this.props.orientation || 'horizontal') == 'horizontal'
                ? 'btn-group btn-group-toggle'
                : 'btn-group-vertical btn-group-toggle'
            return (
                <Fragment>
                    <Label className='mb-0 text-muted' for={this.props.id} value={this.props.label} />
                    <div className={classes} id={this.props.id}>
                        {this.renderOptions()}
                    </div>
                </Fragment>
            );
        }
        else {
            return null
        }
    }
}
