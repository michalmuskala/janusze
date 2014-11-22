$(function (){
    $("body.projects-controller.show-action #comments .reply-comment").submit(function (e) {
        e.preventDefault();
        $(this).siblings("form.simple_form").show();
        $(this).hide();
    });

    $("body.projects-controller.edit-action, body.projects-controller.new-action")
      .find("#video_attachments, #orbitvu_attachments, #image_attachments")
      .on("cocoon:before-remove", function (e, item) {
        $(item).find("input[type=file]").attr("required", false);
    });

    function sort_template(state) {
        var icon = '<i class="fa fa-angle-' + ($(state.element).data('direction') == 'asc' ? 'down' : 'up') + '">'
        return icon + state.text;
    }

    $('body.projects-controller.index-action select#search-sort-by-type').select2({
        minimumResultsForSearch: 7
        // formatResult: sort_template,
        // formatSelection: sort_template,
        // escapeMarkup: function(m) { return m; }
    });
});
