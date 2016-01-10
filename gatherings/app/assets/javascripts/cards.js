define(['jquery'], function($) {
  $(function() {
    $('body').on('click', '*[data-card]', function(event) {
      t = $(event.currentTarget)
      e = $(':checkbox', t);
      if (e.length <= 0) {
        e = $(':radio', t);
      }
      if (e.length > 0) {
        e.prop('checked', !e.is(':checked'));
        event.preventDefault();
        t.removeClass('secondary success').addClass(e.is(':checked') ? 'success' : 'secondary');
      }
    });
  });
});
