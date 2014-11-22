//= require jquery
//= require jquery_ujs
//= require traceur
//= require traceur-runtime
//= require bootstrap-sprockets
//= require bootstrap
//= require select2
//= require_tree .

$(function() {
    $('select:not(.dont-select2ify)').select2({
        minimumResultsForSearch: 6
    });
});