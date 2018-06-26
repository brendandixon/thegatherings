import React from 'react'
import PropTypes from 'prop-types'

class BaseComponent extends React.Component {
    constructor(props) {
        super(props)
    }
}

BaseComponent.propTypes = {
    class: PropTypes.string
}

export default BaseComponent
