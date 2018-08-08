import React from 'react'
import PropTypes from 'prop-types'
import Chart from 'chart.js'
import jQuery from 'jquery'

import BaseComponent from '../BaseComponent'
import { evaluateJSONResponse, readJSONResponse } from '../Utilities/HttpUtilities'

export default class BaseChart extends BaseComponent {
    static propTypes = {
        data: PropTypes.object,
        reportsPath: PropTypes.string.isRequired,
        queryString: PropTypes.string,
        onSuccess: PropTypes.func
    }

    constructor(props) {
        super(props)
        this.state = {
            data: this.props.data,
            chartData: this.transformData(this.props.data)
        }

        this.chartType = 'line'
        this._container = React.createRef()
        this.verb = null

        this.bindData = this.bindData.bind(this)
        this.fetchData = this.fetchData.bind(this)
        this.handleError = this.handleError.bind(this)
        this.handleSuccess = this.handleSuccess.bind(this)
        this.transformData = this.transformData.bind(this)
    }

    componentDidMount() {
        if (jQuery.isEmptyObject(this.state.data)) {
            this.fetchData()
        } else if (jQuery.isEmptyObject(this.state.chartData)) {
            this.bindData(this.transformData(this.state.data))
        }
    }

    componentDidUpdate(prevProps, prevState) {
        if (this.props.queryString != prevProps.queryString) {
            this.fetchData()
        }
    }

    bindData(chartData) {
        if (!jQuery.isEmptyObject(chartData)) {
            new Chart(this._container.current, {
                type: this.chartType,
                data: chartData,
                options: this.chartOptions
            });
        }
    }

    fetchData() {
        let path = this.props.reportsPath + (this.verb ? `/${this.verb}` : '')
        if (this.props.queryString && this.props.queryString.length > 0) {
            path += '?' + this.props.queryString
        }
        fetch(path, {
            credentials: 'same-origin',
            method: 'GET',
            headers: {
                'Content-Type': 'application/json; charset=utf-8'
            }

        })
            .then(readJSONResponse)
            .then(evaluateJSONResponse)
            .then(json => this.handleSuccess(json))
            .catch(error => this.handleError(error))
    }

    handleError(error) {
        // console.log('CHART ERROR')
        // console.log(error)
        this.setState({
            data: {},
            chartData: {}
        })
    }

    handleSuccess(json) {
        // console.log('CHART SUCCESS')
        // console.log(json)
        if (jQuery.isArray(json) && json.length > 0) {
            json = json[0]
        }

        let chartData = this.transformData(json)
        this.bindData(chartData)
        this.setState({
            data: json,
            chartData: chartData
        })
        if (this.props.onSuccess) {
            this.props.onSuccess()
        }
    }

    transformData(data) {
        return data
    }

    render() {
        return (
            <canvas
                ref={this._container}
                className={this.props.className}
            />
        );
    }
}
