$(document).on('turbolinks:load', function() {
  // お気に入りボタンのクリックイベントを設定
  $('.favorite-button').on('click', function(e) {
    e.preventDefault();
    var $this = $(this);
    var recipeId = $this.data('recipe-id');
    var favoriteCount = $this.data('favorite-count');
    var isFavorited = $this.data('favorited');
    var url = isFavorited ? "/public/recipes/" + recipeId + "/favorites" : "/public/recipes/" + recipeId + "/favorites";

    // Ajaxリクエスト
    $.ajax({
      url: url,
      type: isFavorited ? "DELETE" : "POST",
      dataType: "json",
      success: function(data) {
        // お気に入り数を更新
        if (isFavorited) {
          favoriteCount--;
        } else {
          favoriteCount++;
        }
        $this.data('favorite-count', favoriteCount);
        $this.data('favorited', !isFavorited);
        $this.html(isFavorited ? '♡' + favoriteCount + ' 作ってみたい！' : '♥' + favoriteCount + ' 作ってみたい！');
      },
      error: function() {
        alert('エラーが発生しました。もう一度お試しください。');
      }
    });
  });
});
