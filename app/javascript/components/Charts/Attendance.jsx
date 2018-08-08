import jQuery from 'jquery'

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
            legend: {
                labels: {
                    fontSize: 20
                },
                position: 'bottom'
            },
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
        this.verb = 'attendance'
    }

    transformData(data) {
        if (jQuery.isEmptyObject(data) || jQuery.isEmptyObject(data.attendance)) {
            return null
        }

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
                backgroundColor: 'rgba(0, 123, 255, 0.5)',
                borderColor: 'rgba(0, 123, 255, 0.7)',
                borderWidth: 1
            },
            {
                label: 'Absent',
                data: absent,
                backgroundColor: 'rgba(200, 200, 200, 0.5)',
                borderColor: 'rgba(100, 100, 100, 0.5)',
                borderWidth: 1
            }]
        }
     }
}
