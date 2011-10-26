$(document).ready(function(){
  $('.name', '#runs li').click(function(){
    $(this).parent().toggleClass('hide_details');
  });

  $('.add_distance_field').click(function(){
    $('<br/>').appendTo('#distances');
    $('input.distance:first').clone().addClass('distance_clone').val("").appendTo('#distances');
  });
});