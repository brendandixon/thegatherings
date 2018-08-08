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
        this.verb = 'gap'
    }

    transformData(data) {
        if (jQuery.isEmptyObject(data) || jQuery.isEmptyObject(data.gaps)) {
            return null
        }

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
                backgroundColor: 'rgba(0, 123, 255, 0.5)',
                borderColor: 'rgba(0, 123, 255, 0.7)',
                borderWidth: 1
            },
            {
                label: 'Requested',
                data: requested,
                backgroundColor: 'rgba(200, 200, 200, 0.5)',
                borderColor: 'rgba(100, 100, 100, 0.5)',
                borderWidth: 1
            }]
        }
    }
}
