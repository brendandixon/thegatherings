if (theGatherings.Charts !== undefined) {
  /*
    C3.js
    http://c3js.org/
  */
  theGatherings.Charts.drawAttendance = function(o) {

    var chart = c3.generate({
      bindto : o.container,
      data : {
        rows: o.data,
        colors : {
          "Present" : "#2199e8",
          "Absent" : "#777"
        },
        labels: true,
        type : "bar",
        groups: [
          ["Present", "Absent"]
        ]
      },
      grid : {
        y : {
          show: true
        }
      },
      size : {
        height : 400,
        width : 1000
      },
      axis : {
        x : {
          tick : {
            // fit : true,
            // centered : true,
            outer : false
          },
          type : 'category',
          categories: o.categories
        }
      }
    });
  };

  theGatherings.Charts.drawGap = function(o) {

    var chart = c3.generate({
      bindto : o.container,
      data : {
        rows: o.data,
        colors : {
          "Available" : "#2199e8",
          "Requests" : "#777"
        },
        labels: true,
        type : "area-spline"
      },
      grid : {
        y : {
          show: true
        }
      },
      size : {
        height : 400,
        width : 1000
      },
      axis : {
        x : {
          tick : {
            // fit : true,
            // centered : true,
            outer : false
          },
          type : 'category',
          categories: o.categories
        }
      }
    });
  };

  theGatherings.Charts.bindCharts = function() {
    if (theGatherings.Charts.gap_data !== undefined) {
      for (i=0; i < theGatherings.Charts.gap_data.length; i++) {
        theGatherings.Charts.drawGap(theGatherings.Charts.gap_data[i]);
      }
    }

    if (theGatherings.Charts.attendance_data !== undefined) {
      theGatherings.Charts.drawAttendance(theGatherings.Charts.attendance_data);
    }
  }

  $(function() {
    theGatherings.Charts.bindCharts();
  });

  /*
    Consider http://dimplejs.org
    http://nvd3-community.github.io/nvd3/
  */
  /*
    D3plus.js
  var charts = [
    {
      panelID : "#age_groups",
      chartID : "#age-group-chart",
      chart   : null,
      data    : [
          { "id" : 0, "category" : "20's", "name" : "Available", "value" : 5},
          { "id" : 1, "category" : "30's", "name" : "Available", "value" : 5},
          { "id" : 2, "category" : "40's", "name" : "Available", "value" : 10},
          { "id" : 3, "category" : "50's", "name" : "Available", "value" : 10},
          { "id" : 4, "category" : "60's", "name" : "Available", "value" : 5},
          { "id" : 5, "category" : "Plus", "name" : "Available", "value" : 5},

          { "id" : 0, "category" : "20's", "name" : "Requests", "value" : 20},
          { "id" : 1, "category" : "30's", "name" : "Requests", "value" : 10},
          { "id" : 2, "category" : "40's", "name" : "Requests", "value" : 10},
          { "id" : 3, "category" : "50's", "name" : "Requests", "value" : 15},
          { "id" : 4, "category" : "60's", "name" : "Requests", "value" : 5},
          { "id" : 5, "category" : "Plus", "name" : "Requests", "value" : 5}
      ],
      labels : ["20s", "30s", "40s", "50s", "60s", "Beyond"]
    },
    {
      panelID : "#life_stages",
      chartID : "#life-stage-chart",
      chart   : null,
      data    : [
          { "id" : 0, "category" : "College",            "name" : "Available", "value" : 2 },
          { "id" : 1, "category" : "Post-College",       "name" : "Available", "value" : 8 },
          { "id" : 2, "category" : "Early Career",       "name" : "Available", "value" : 5 },
          { "id" : 3, "category" : "Established Career", "name" : "Available", "value" : 15 },
          { "id" : 4, "category" : "Post-Career",        "name" : "Available", "value" : 5 },
          
          { "id" : 0, "category" : "College",            "name" : "Requests", "value" : 0 },
          { "id" : 1, "category" : "Post-College",       "name" : "Requests", "value" : 20 },
          { "id" : 2, "category" : "Early Career",       "name" : "Requests", "value" : 10 },
          { "id" : 3, "category" : "Established Career", "name" : "Requests", "value" : 10 },
          { "id" : 4, "category" : "Post-Career",        "name" : "Requests", "value" : 0 }
      ],
      labels : ["College", "Post-College", "Early Career", "Established Career", "Post-Career"]
    },
    {
      panelID : "#relationships",
      chartID : "#relationship-chart",
      chart   : null,
      data    : [
          { "id" : 0, "category" : "Single",             "name" : "Available", "value" : 4 },
          { "id" : 1, "category" : "Young Married",      "name" : "Available", "value" : 0 },
          { "id" : 2, "category" : "Early Family",       "name" : "Available", "value" : 5 },
          { "id" : 3, "category" : "Established Family", "name" : "Available", "value" : 8 },
          { "id" : 4, "category" : "Empty Nester",       "name" : "Available", "value" : 3 },
          { "id" : 5, "category" : "Divorced",           "name" : "Available", "value" : 1 },
          
          { "id" : 0, "category" : "Single",             "name" : "Requests", "value" : 10 },
          { "id" : 1, "category" : "Young Married",      "name" : "Requests", "value" : 5 },
          { "id" : 2, "category" : "Early Family",       "name" : "Requests", "value" : 8 },
          { "id" : 3, "category" : "Established Family", "name" : "Requests", "value" : 5 },
          { "id" : 3, "category" : "Empty Nester",       "name" : "Requests", "value" : 2 },
          { "id" : 4, "category" : "Divorced",           "name" : "Requests", "value" : 0 }
      ],
      labels : ["Single", "Young Married", "Early Family", "Established Family", "Empty Nester", "Divorced"]
    },
    {
      panelID : "#genders",
      chartID : "#gender-chart",
      chart   : null,
      data    : [
          { "id" : 0, "category" : "Women Only",         "name" : "Available", "value" : 10 },
          { "id" : 1, "category" : "Men Only",           "name" : "Available", "value" : 2 },
          { "id" : 2, "category" : "Mixed",              "name" : "Available", "value" : 23 },

          { "id" : 0, "category" : "Women Only",         "name" : "Requests", "value" : 21 },
          { "id" : 1, "category" : "Men Only",           "name" : "Requests", "value" : 4 },
          { "id" : 2, "category" : "Mixed",              "name" : "Requests", "value" : 15 }
      ],
      labels : ["Women Only", "Men Only", "Mixed"]
    }
  ]

  theGatherings.Charts.draw = function(container, data, categories) {
    return d3plus.viz()
      .container(container)
      .data(data)
      .class("chart-point")
      .type("area")
      .id("name")
      .text("name")
      .y("value")
      .x("id")
      .shape({
        "interpolate" : "cardinal"
      })
      .tooltip(["category", "value"])
      .draw();
  };

  theGatherings.Charts.bindCharts = function() {

    for (i = 0; i < charts.length; i++) {
      if ($(charts[i].panelID + ":visible").length > 0) {
        if (charts[i].chart == null) {
          charts[i].chart = theGatherings.Charts.draw(charts[i].chartID, charts[i].data, charts[i].labels);
          break;
        }
      }
    }
  };

  $(function() {
    theGatherings.Charts.bindCharts();
    $('#tabs').on('change.zf.tabs', function (event, tab) {
      theGatherings.Charts.bindCharts();
    });
  */
}
