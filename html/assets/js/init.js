$(document).ready(function(){

  // LUA event listener
  window.addEventListener('message', function(event) {
      if (event.data.action == 'open') {
        $('#plate').show();
      }
  });

  // Close the NUI, ESC
  $(document).keyup(function(e) {
    if (e.keyCode == 27) {
      $('#plate').hide();
      $.post('http://jsfour-licenseplate/escape', JSON.stringify({
        number: $('#number').val()
      }));
    }
  });
});
