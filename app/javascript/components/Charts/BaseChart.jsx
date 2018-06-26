import React from 'react'
import PropTypes from 'prop-types'
import BaseComponent from '../BaseComponent'
import Chart from 'chart.js'

export default class BaseChart extends BaseComponent {
    static propTypes = {
        data: PropTypes.object.isRequired,
        url: PropTypes.string.isRequired
    }

    constructor(props) {
        super(props)
        this.chartType = 'line'
        this.container = React.createRef()
        this.state = {
            data: {},
            chartData: this.transformData(this.props.data)
        }
    }


    bindData() {
        let myChart = new Chart(this.container.current, {
            type: this.chartType,
            data: this.state.chartData,
            options: this.chartOptions
        });
    }

    transformData(data = this.props.data) {
        return data
    }

    fetchData() {
        let component = this
        fetch(this.props.url, {
                credentials: 'same-origin'
            })
            .then(function(response) {
                response.json()
                    .then(function(data) {
                        component.setState({ data: data, chartData: component.transformData(data) })
                        component.bindData()
                    })

            })
    }

    componentDidMount() {
        // this.fetchData()
        this.bindData()
    }

    render() {
        return (
            <canvas ref={this.container} className={this.props.class} />
        );
    }
}
