if (theGatherings.Dates !== undefined) {
  theGatherings.Dates.bindDates = function() {
    datefields = $('*[data-datefield]');
    datefields.datepicker({
      dateFormat: 'MM d, yy',
      minDate: '-10y',
      maxDate: '6m',
      showAnim: 'slideDown'
    });
    datefields.each(function(i, e) {
      var e = $(e);
      if (e.val().toString().length > 0) {
        e.val($.datepicker.formatDate('MM d, yy', new Date(e.val())));
      }
    });
  }

  $(function() {
    theGatherings.Dates.bindDates();
  });
}
