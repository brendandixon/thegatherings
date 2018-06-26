import React from 'react'
import PropTypes from 'prop-types'
import BaseComponent from '../BaseComponent'

export default class ButtonBox extends BaseComponent {
    static propTypes = {
        id: PropTypes.string.isRequired,
        isChecked: PropTypes.bool,
        name: PropTypes.string.isRequired
    }

    constructor(props) {
        super(props)
        this._input = null
        this.state = { isChecked: this.props.isChecked || false }

        this.checkedClass = this.checkedClass.bind(this)
        this.handleClick = this.handleClick.bind(this)
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

    handleClick(event) {
        event.preventDefault()

        let isChecked = this.state.isChecked
        let btn = jQuery(this._input)
        let checkbox = jQuery(`#${this.props.id}`)

        btn.removeClass(this.checkedClass(isChecked))
        
        isChecked = !isChecked
        btn.addClass(this.checkedClass(isChecked))

        checkbox.prop('checked', isChecked)
        this.setState({ isChecked: isChecked })
    }

    render() {
        return (
            <div
                className={`btn btn-block ${this.checkedClass(this.state.isChecked)} ${this.props.className}`}
                style={this.props.style}
                onClick={this.handleClick}
                ref={c => (this._input = c)}
            >
                <input name={this.props.name} type='hidden' value='0' />
                <input
                    checked={this.state.isChecked}
                    className='d-none'
                    id={this.props.id}
                    name={this.props.name}
                    type='checkbox'
                    onChange={this.handleChange}
                />
                {this.props.children}
            </div>
        );
    }
}
