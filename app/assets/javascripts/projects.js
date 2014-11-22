$(function (){
  $("#comments .reply-comment").submit(function (e) {
    e.preventDefault();
    $(this).siblings("form.simple_form").show();
    $(this).hide();
  });
});
