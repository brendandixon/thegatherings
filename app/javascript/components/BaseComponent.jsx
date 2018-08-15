import React from 'react'
import PropTypes from 'prop-types'

export default class BaseComponent extends React.Component {
    static propTypes = {
        class: PropTypes.string
    }

    constructor(props) {
        super(props)
    }
}
