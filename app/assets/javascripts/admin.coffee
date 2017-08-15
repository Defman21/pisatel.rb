window.editors =
  new_post: null
  update_post: null

mce = document.createElement 'script'
mce.src = 'https://cdn.jsdelivr.net/simplemde/latest/simplemde.min.js'
mce.async = yes
mce.onreadystatechange = mce.onload = ->
  editors.new_post = new SimpleMDE {
    element: document.querySelector '#new-post-body'
    status: no
    toolbar: no
    autoDownloadFontAwesome: no
  }
  editors.update_post = new SimpleMDE {
    element: document.querySelector '#update-post-body'
    status: no
    toolbar: no
    autoDownloadFontAwesome: no
  }
document.querySelector('head').appendChild mce

parseHash = (hash) ->
  storage = {}
  hash.split(';').map (item) ->
    [key, value] = item.split '='
    storage[key] = value
    null
  storage


window.app = new Vue
  el: '#main'
  data:
    posts: $posts
    page: 'new-post'
    post: []
    actions:
      draft: 'Save'
      publish: 'Update & Publish'
  methods:
    openPage: (page) ->
      @page = page
    currentPage: (page) ->
      {
        active: page is @page
      }
    currentButton: (page) ->
      {
        active: page is @page
      }
    publishStatus: (bool) ->
      if bool is true then 'published' else 'unpublished'
    openPost: (post) ->
      return unless post?
      @post = post
      if post.published
        @actions =
          draft: 'Save & Unpublish'
          publish: 'Update'
      else
        @actions =
          draft: 'Save'
          publish: 'Publish'
      editors.update_post.value post.body
      @openPage 'update-post'
      setTimeout((-> @codemirror.refresh()).bind(editors.update_post), 0)

if location.hash
  data = parseHash location.hash.substring 1
  if data.page?
    app.openPage data.page
  else
    location.hash = '#page=new-post'

window.addEventListener 'hashchange', ->
  data = parseHash location.hash.substring 1
  if data.page?
    app.openPage data.page
  else if data.post?
    app.openPost $posts.find (post) -> post.id is parseInt data.post