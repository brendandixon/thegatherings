if (theGatherings.Charts !== undefined) {

  //
  // http://www.chartjs.org
  //

  theGatherings.Charts.drawAttendance = function(o) {
    var ctx = document.getElementById(o.container + '_chart');
    var myChart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: o.labels,
        datasets: [{
          label: o.present.name,
          data: o.present.values,
          backgroundColor: 'rgba(50, 50, 155, 0.5)',
          borderColor: 'rgba(50, 50, 155, 0.7)',
          borderWidth: 1
        },
        {
          label: o.absent.name,
          data: o.absent.values,
          backgroundColor: 'rgba(20, 20, 255, 0.2)',
          borderColor: 'rgba(20, 20, 255, 0.5)',
          borderWidth: 1
        }]
      },
      options: {
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
    });
  };

  theGatherings.Charts.drawGap = function(o) {
    var ctx = document.getElementById(o.container + '_chart');
    var myChart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: o.labels,
        datasets: [{
          label: o.available.name,
          data: o.available.values,
          backgroundColor: 'rgba(50, 50, 155, 0.5)',
          borderColor: 'rgba(50, 50, 155, 0.7)',
          borderWidth: 1
        },
        {
          label: o.requests.name,
          data: o.requests.values,
          backgroundColor: 'rgba(20, 20, 255, 0.2)',
          borderColor: 'rgba(20, 20, 255, 0.5)',
          borderWidth: 1
        }]
      },
      options: {
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
    });
  };

  theGatherings.Charts.bindCharts = function() {
    if (theGatherings.Charts.gaps_data !== undefined) {
      for (i=0; i < theGatherings.Charts.gaps_data.length; i++) {
        theGatherings.Charts.drawGap(theGatherings.Charts.gaps_data[i]);
      }
    }

    if (theGatherings.Charts.attendance_data !== undefined) {
      for (i=0; i < theGatherings.Charts.attendance_data.length; i++) {
        theGatherings.Charts.drawAttendance(theGatherings.Charts.attendance_data[i]);
      }
    }
  }

  $(function() {
    theGatherings.Charts.bindCharts();
  });
}
