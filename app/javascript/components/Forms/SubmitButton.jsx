import React from 'react'
import PropTypes from 'prop-types'

import BaseComponent from '../BaseComponent';

export default class SubmitButton extends BaseComponent {
    static propTypes = {
        title: PropTypes.string.isRequired,
        position: PropTypes.oneOf(['full', 'left', 'center', 'right'])
    }

    constructor(props) {
        super(props)
        this._submitButton = null
    }

    componentDidUpdate(prevProps, prevState) {
        this.ensureEnabled()
    }

    componentDidMount() {
        this.ensureEnabled()
    }

    ensureEnabled() {
        if (this._submitButton) {
            jQuery(this._submitButton).removeAttr('disabled')
        }
    }

    render() {
        let rowClasses = 'w-100 p-0 m-0 row '
        let colClasses = 'w-100 p-0 m-0 col-'
        if (this.props.position == 'full') {
            colClasses += '12'
        } else {
            colClasses += '4'
            switch (this.props.position) {
                case 'left':
                    rowClasses += 'justify-content-start'
                    break
                case 'center':
                    rowClasses += 'justify-content-center'
                    break
                case 'right':
                default:
                    rowClasses += 'justify-content-end'
            }
        }
        return (
            <div className='container w-100 p-0 mt-2 mx-0'>
                <div className={rowClasses}>
                    <div className={colClasses}>
                        <input
                            type='submit'
                            value={this.props.title}
                            className='w-100 btn btn-outline-primary'
                            data-disable-with={this.props.title}
                            ref={c => (this._submitButton = c)}
                        />
                    </div>
                </div>
            </div>
        );
    }
}
