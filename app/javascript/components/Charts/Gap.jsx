import BaseChart from './BaseChart'

// JSON data format
// {
//   groupType: <group>,
//   groupId: <group_id>
//   category: <string>,
//   single: <string>,
//   plural: <string>,
//   gaps : [
//     {
//       name: <string>,
//       available: <num>,
//       requested: <num>
//     }
//     . . .
//   ]
// }
export default class Gap extends BaseChart {
    constructor(props) {
        super(props)
        this.chartType = 'line'
        this.chartOptions = {
            scales: {
                xAxes: [{
                    stacked: true
                }],
                yAxes: [{
                    stacked: true
                }]
            },
            tooltips: {
                mode: 'index',
                intersect: false,
                position: 'nearest'
            }
        }
    }

    transformData(data = this.props.data) {
        let labels = []
        let available = []
        let requested = []
        for (let item of data.gaps) {
            labels.push(item.name)
            available.push(item.available)
            requested.push(item.requested)
        }

        return {
            labels: labels,
            datasets: [{
                label: 'Available',
                data: available,
                backgroundColor: 'rgba(50, 50, 155, 0.5)',
                borderColor: 'rgba(50, 50, 155, 0.7)',
                borderWidth: 1
            },
            {
                label: 'Requested',
                data: requested,
                backgroundColor: 'rgba(20, 20, 255, 0.2)',
                borderColor: 'rgba(20, 20, 255, 0.5)',
                borderWidth: 1
            }]
        }
    }
}
