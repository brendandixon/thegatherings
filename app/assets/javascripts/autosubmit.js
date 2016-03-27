if (theGatherings.Autosubmit !== undefined) {
  $(function() {
    $('body').on('change', '*[data-autosubmit]', function(event) {
      $(this).closest("form").submit();
    });
  });
}
