import React from 'react'
import PropTypes from 'prop-types'
import BaseComponent from '../BaseComponent'
import Label from './Label';

export default class LabeledInput extends BaseComponent {
    static propTypes = {
        hasFocus: PropTypes.bool,
        id: PropTypes.string.isRequired,
        label: PropTypes.string.isRequired,
        name: PropTypes.string.isRequired,
        type: PropTypes.string.isRequired,
        value: PropTypes.string
    }

    constructor(props) {
        super(props)
        this._input = null
        this.state = {value: this.props.value || ''}
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
        this.setState({value: event.target.value})
    }

    render() {
        return (
            <div className='form-group'>
                <Label className='mb-0' for={this.props.id} value={this.props.label} />
                <input
                    className='w-100 text-muted form-control'
                    id={this.props.id}
                    name={this.props.name}
                    type={this.props.type}
                    value={this.state.value}
                    ref={c => (this._input = c)}
                    onChange={this.handleChange}
                />
            </div>
        );
    }
}
