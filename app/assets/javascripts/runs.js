$(document).ready(function(){
  $('.name', '#runs li').click(function(){
    $(this).parent().toggleClass('hide_details');
  });
});