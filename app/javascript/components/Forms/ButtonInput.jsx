import React from 'react'
import PropTypes from 'prop-types'
import BaseComponent from '../BaseComponent'

export default class ButtonInput extends BaseComponent {
    static propTypes = {
        id: PropTypes.string.isRequired,
        isChecked: PropTypes.bool,
        name: PropTypes.string.isRequired,
        type: PropTypes.oneOf(['checkbox', 'radio']),
        value: PropTypes.string.isRequired,
        onClick: PropTypes.func.isRequired
    }

    constructor(props) {
        super(props)
        this.checkedClass = this.checkedClass.bind(this)
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

    render() {
        return (
            <label
                className={`btn btn-block ${this.checkedClass(this.props.isChecked)} ${this.props.className}`}
                style={this.props.style}
                ref={c => (this._input = c)}
                onClick={this.props.onClick}
            >
                <input
                    checked={this.props.isChecked}
                    className='d-none'
                    id={this.props.id}
                    name={this.props.name}
                    type={this.props.type}
                    value={this.props.value}
                />
                {this.props.children}
            </label>
        );
    }
}
