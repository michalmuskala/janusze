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

    var $tags = $('body.projects-controller form #project_tag_list');

    $tags.select2({
        tags: true,
        initSelection: function(element, callback) {
            var data = [];
            _.each($tags.val().split(","), function(tag) {
                data.push({ id: tag, text: tag });
            });

            callback(data);
        },
        createSearchChoice: function(term) {
          return {
            id: term,
            text: term,
            count: 0
          }
        },
        tokenSeparators: [","],
        minimumInputLength: 1,
        ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
            url: '/projects/tags',
            dataType: 'json',
            data: function (term, page) {
                return {
                    term: term
                };
            },
            results: function (data, page) {
                return {
                    results: data.tags
                };
            }
        }
    });

    var $stars = $('body.projects-controller.show-action .title-overlay .rating .stars');

    $stars.on('mouseleave', function(e) {
        $stars.find('.star').removeClass('force-empty force-full');
    })

    $stars.on('mouseover', 'a.star', function() {
        var $star = $(this);

        $stars.find('.star').removeClass('force-empty force-full');
        $star.addClass('force-full');
        $star.prevAll().addClass('force-full');
        $star.nextAll().addClass('force-empty');
    });
});
