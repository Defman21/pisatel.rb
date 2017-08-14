$app = new Vue
  el: '.app'
  data:
    posts: $posts ? $posts : []
    post: $post ? $post : []