define(['jquery', 'Chartjs'], function($, chartsjs) {
    var chart;

    $(function() {

      $('body').on('bind.charts', function(event) {
        var ctx, data;

        charts = $('*[data-chart]');
        
        ctx = charts.get(0).getContext("2d");
        if (ctx.canvas['offsetHeight'] != 0) {
          data = {
            labels: ["20s", "30s", "40s", "50s", "60s", "Beyond"],
            datasets: [
                {
                    label: "Available",
                    fillColor: "rgba(151,187,205,0.2)",
                    strokeColor: "rgba(151,187,205,1)",
                    pointColor: "rgba(151,187,205,1)",
                    pointStrokeColor: "#fff",
                    pointHighlightFill: "#fff",
                    pointHighlightStroke: "rgba(151,187,205,1)",
                    data: [5, 5, 10, 10, 5, 5]
                },
                {
                    label: "Requests",
                    fillColor: "rgba(220,220,220,0.2)",
                    strokeColor: "rgba(220,220,220,1)",
                    pointColor: "rgba(220,220,220,1)",
                    pointStrokeColor: "#fff",
                    pointHighlightFill: "#fff",
                    pointHighlightStroke: "rgba(220,220,220,1)",
                    data: [20, 10, 10, 15, 5, 5]
                }
            ]
          };
          if (chart !== undefined) {
            chart.destroy();
          }
          chart = new Chart(ctx).Line(data);
        }

        ctx = charts.get(1).getContext("2d");
        if (ctx.canvas['offsetHeight'] != 0) {
          data = {
            labels: ["College", "Post-College", "Early Career", "Established Career", "Post-Career"],
            datasets: [
                {
                    label: "Available",
                    fillColor: "rgba(151,187,205,0.2)",
                    strokeColor: "rgba(151,187,205,1)",
                    pointColor: "rgba(151,187,205,1)",
                    pointStrokeColor: "#fff",
                    pointHighlightFill: "#fff",
                    pointHighlightStroke: "rgba(151,187,205,1)",
                    data: [2, 8, 5, 15, 5]
                },
                {
                    label: "Requests",
                    fillColor: "rgba(220,220,220,0.2)",
                    strokeColor: "rgba(220,220,220,1)",
                    pointColor: "rgba(220,220,220,1)",
                    pointStrokeColor: "#fff",
                    pointHighlightFill: "#fff",
                    pointHighlightStroke: "rgba(220,220,220,1)",
                    data: [0, 20, 10, 10, 0]
                }
            ]
          };
          if (chart !== undefined) {
            chart.destroy();
          }
          chart = new Chart(ctx).Line(data);
        }

        ctx = charts.get(2).getContext("2d");
        if (ctx.canvas['offsetHeight'] != 0) {
          data = {
            labels: ["Single", "Young Married", "Early Family", "Established Family", "Empty Nester", "Divorced"],
            datasets: [
                {
                    label: "Available",
                    fillColor: "rgba(151,187,205,0.2)",
                    strokeColor: "rgba(151,187,205,1)",
                    pointColor: "rgba(151,187,205,1)",
                    pointStrokeColor: "#fff",
                    pointHighlightFill: "#fff",
                    pointHighlightStroke: "rgba(151,187,205,1)",
                    data: [4, 0, 5, 8, 3, 1]
                },
                {
                    label: "Requests",
                    fillColor: "rgba(220,220,220,0.2)",
                    strokeColor: "rgba(220,220,220,1)",
                    pointColor: "rgba(220,220,220,1)",
                    pointStrokeColor: "#fff",
                    pointHighlightFill: "#fff",
                    pointHighlightStroke: "rgba(220,220,220,1)",
                    data: [10, 5, 8, 5, 2, 0]
                }
            ]
          };
          if (chart !== undefined) {
            chart.destroy();
          }
          chart = new Chart(ctx).Line(data);
        }

        ctx = charts.get(3).getContext("2d");
        if (ctx.canvas['offsetHeight'] != 0) {
          data = {
            labels: ["Women Only", "Men Only", "Mixed"],
            datasets: [
                {
                    label: "Available",
                    fillColor: "rgba(151,187,205,0.2)",
                    strokeColor: "rgba(151,187,205,1)",
                    pointColor: "rgba(151,187,205,1)",
                    pointStrokeColor: "#fff",
                    pointHighlightFill: "#fff",
                    pointHighlightStroke: "rgba(151,187,205,1)",
                    data: [10, 2, 23]
                },
                {
                    label: "Requests",
                    fillColor: "rgba(220,220,220,0.2)",
                    strokeColor: "rgba(220,220,220,1)",
                    pointColor: "rgba(220,220,220,1)",
                    pointStrokeColor: "#fff",
                    pointHighlightFill: "#fff",
                    pointHighlightStroke: "rgba(220,220,220,1)",
                    data: [21, 4, 15]
                }
            ]
          };
          if (chart !== undefined) {
            chart.destroy();
          }
          chart = new Chart(ctx).Line(data);
        }
      });

      $('#tabs').on('change.zf.tabs', function (event, tab) {
        setTimeout(function() {$('body').trigger('bind.charts');}, 1);
      });
      $('body').trigger('bind.charts');
    });
});

