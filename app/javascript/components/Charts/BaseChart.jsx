import React, { Fragment } from 'react'
import PropTypes from 'prop-types'
import Chart from 'chart.js'
import jQuery from 'jquery'

import BaseComponent from '../BaseComponent'
import fetchTimeout from '../Utilities/FetchTimeout'
import { evaluateJSONResponse, readJSONResponse } from '../Utilities/HttpUtilities'

export default class BaseChart extends BaseComponent {
    static propTypes = {
        data: PropTypes.object,
        reportsPath: PropTypes.string.isRequired,
        queryString: PropTypes.string,
        onError: PropTypes.func,
        onReady: PropTypes.func
    }

    constructor(props) {
        super(props)
        
        let chartData = jQuery.isEmptyObject(this.props.data)
            ? {}
            : this.transformData(this.props.data)

        this.state = {
            data: this.props.data,
            chartData: chartData,
            subtitle: null,
            errorMessage: null
        }

        this.chartType = 'line'
        this._container = React.createRef()
        this.verb = null

        this.bindData = this.bindData.bind(this)
        this.fetchData = this.fetchData.bind(this)
        this.handleError = this.handleError.bind(this)
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

    componentWillUnmount() {
        // TODO: Add code to "cancel" outstanding fetch
        // - This can either be by wrapping the Promise to track a canceled state or
        //   by hoisting the fetch up a level (or two) and using a token to track / cancel
        //   as needed
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

        if (this.props.onReady) {
            this.props.onReady(false)
        }

        fetchTimeout(path, {
            credentials: 'same-origin',
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json; charset=utf-8'
            }

        })
            .then(readJSONResponse)
            .then(evaluateJSONResponse)
            .then(json => {
                if (jQuery.isArray(json) && json.length > 0) {
                    json = json[0]
                }

                let chartData = this.transformData(json)
                this.bindData(chartData)
                this.setState({
                    data: json,
                    chartData: chartData,
                    errorMessage: null
                })
            })
            .then(() => {
                if (this.props.onReady) {
                    this.props.onReady(true)
                }
            })
            .catch(error => this.handleError(error))
    }

    handleError(error) {
        console.log(error)
        this.setState({
            data: {},
            chartData: {},
            errorMessage: 'Unable to retrieve data'
        })

        if (this.props.onError) {
            this.props.onError()
        }
        if (this.props.onReady) {
            this.props.onReady(true)
        }
    }

    transformData(data) {
        return data
    }

    render() {
        let state = this.state
        let classes = this.props.className ? this.props.className : ''
        let errorMessage = state.errorMessage
        return (
            <Fragment>
                <div className={`display-3 text-center text-muted pt-4 ${errorMessage ? 'd-block' : 'd-none'}`}>
                    {errorMessage}
                </div>
                <canvas
                    ref={this._container}
                    className={`${classes} ${errorMessage ? 'd-none' : 'd-block'}`}
                />
                {state.subtitle}
            </Fragment>
        );
    }
}
