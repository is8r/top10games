$(function() {

  $.ajax({
    type: 'GET',
    dataType: 'json',
    cache: false,
    url: 'ruby/dist/rank.json'
  }).done(function(e) {
    createTable(e);
    $('.js-title').text(e.length);
  }).fail(function() {
    trace( "error" );
  });

  function createTable(data) {
    _.templateSettings = {interpolate : /\{\{(.+?)\}\}/g};
    var template_tr = _.template("<tr><td>{{ key }}</td><td>{{ value }}</td></tr>");
    for(var i in data){
      var html = template_tr({key: i, value: data[i]});
      $(html).appendTo('.js-table > tbody');
    }
    var $table = $('.js-table').stupidtable();
    var $th_to_sort = $table.find("thead th").eq(1);
    $th_to_sort.stupidsort('desc');
  }

});
