import BaseChart from './BaseChart'

// JSON data format:
// {
//  groupType: <group>,
//  groupId: <group_id>,
//  attendance : [
//      {
//          date : <date>,
//          present : <num>,
//          absent  : <num>
//      },
//      . . .
//  ]
// }
export default class Attendance extends BaseChart {
    constructor(props) {
        super(props)
        this.chartType = 'bar'
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
                position: 'average'
            }
        }
    }

    transformData(data = this.props.data) {
        let labels = []
        let present = []
        let absent = []
        for (let item of data.attendance) {
            labels.push(item.date)
            present.push(item.present)
            absent.push(item.absent)
        }

        return {
            labels: labels,
            datasets: [{
                label: 'Present',
                data: present,
                backgroundColor: 'rgba(50, 50, 155, 0.5)',
                borderColor: 'rgba(50, 50, 155, 0.7)',
                borderWidth: 1
            },
            {
                label: 'Absent',
                data: absent,
                backgroundColor: 'rgba(20, 20, 255, 0.2)',
                borderColor: 'rgba(20, 20, 255, 0.5)',
                borderWidth: 1
            }]
        }
     }
}
