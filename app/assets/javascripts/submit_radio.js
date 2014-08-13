
$(document).on( 'page:change', function() {
  $('input[type=radio]').click(function() {
    $(".form").submit();
  });
});