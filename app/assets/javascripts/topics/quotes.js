$( document ).ready(function() {
  $('button.quotes').on('click',function(){
    var user = $($(this).parents(".table").find("a.forum-title")[0]).text();
    var text = "";
    if (window.getSelection) {
      text = window.getSelection().toString();
    } else if (document.selection && document.selection.type != "Control") {
      text = document.selection.createRange().text;
    }
    $('.trix-content').prepend(user + ' quotes: <pre>' + text + '</pre><br /> ');
  });
});