$(document).ready(function(){
$('#participant_run_id').change(function(){
  if (typeof distances[$(this).val()] == "undefined") {
    $('#participant_distance_id').html('');
    return;
  }
  var selected_distances = distances[$(this).val()]
    , distances_html = '';
  $.each(selected_distances, function(id, distance) {
    distances_html += '<option value="'+id+'">'+distance+' km</option>';
  });
  $('#participant_distance_id').html(distances_html);
});
});