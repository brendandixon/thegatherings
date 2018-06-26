import React, { Fragment } from 'react'
import jQuery from 'jquery'

import BaseComponent from '../BaseComponent'

export default class RailsAuthenticator extends BaseComponent {
    constructor(props) {
        super(props)
        this.authenticityParam = jQuery('head > meta[name=csrf-param]').attr('content')
        this.authenticityToken = jQuery('head > meta[name=csrf-token]').attr('content')
    }

    render() {
        return (
            <Fragment>
                <input name='utf8' type='hidden' value='&#x2713;' />
                <input name={this.authenticityParam} type='hidden' value={this.authenticityToken} />
            </Fragment>
        )
    }
}
