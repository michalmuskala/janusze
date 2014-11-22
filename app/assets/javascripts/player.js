(function () {
  function loadPlayer () {
    var tag = document.createElement('script');

    tag.src = "https://www.youtube.com/iframe_api";
    var firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
  }

  function enablePlayer (dom_id, video_id) {
    new YT.Player(dom_id, { height: '390',
                            width: '640',
                            videoId: video_id });
  }

  $(function () {
    videos = $("#attachments .video");
    if (_.any(videos)) {
      loadPlayer();
      window.onYouTubeIframeAPIReady = function () {
        videos.each(function(i, elem) {
          enablePlayer(elem.id, $(elem).data('video-id'));
       });
      }
    }
  });
})(this)
