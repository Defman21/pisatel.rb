$ = (query) ->
  if typeof query is 'string' # Query String
    nodes = document.querySelectorAll query
    if nodes.length is 1
      nodes = nodes[0]
  else if typeof query is 'object' # DOM node
    nodes = query
  _nodes = nodes
  return {
    siblings: ->
      return @ if nodes.length > 1
      nodes = Array.prototype.filter.call nodes.parentNode.children, (child) ->
        nodes isnt child
      @
    filter: (callback) ->
      nodes = nodes.filter callback
      @
    addClass: (name) ->
      unless Array.isArray nodes
        nodes.classList.add name
        return @
      for node in nodes
        node.classList.add name
      @
    removeClass: (name) ->
      unless Array.isArray nodes
        nodes.classList.remove name
        return @
      for node in nodes
        node.classList.remove name
      @
    reset: ->
      nodes = _nodes
      @
    $: -> nodes
  }

window.openPage = (page, menuItem = null) ->
  $(".page##{page}")
    .siblings()
    .removeClass('active')
    .reset()
    .addClass 'active'
  if menuItem isnt null
    $(menuItem)
      .siblings()
      .filter((elem) -> elem.classList.value.indexOf('button') isnt -1)
      .removeClass('active')
      .reset()
      .addClass 'active'

proceedHash = (hash) ->
  params = hash.split '&'
  for param in params
    [key, value] = param.split '='
    if key == 'page'
      openPage value, "##{value}_btn"

document.addEventListener 'DOMContentLoaded', (event) ->
  editors = []
  mce = document.createElement 'script'
  mce.src = 'https://cdn.jsdelivr.net/simplemde/latest/simplemde.min.js'
  mce.async = yes
  mce.onreadystatechange = mce.onload = ->
    editors['new_post_body'] = new SimpleMDE {element: $('#new_post_body').$()}
    editors['post_body'] = new SimpleMDE {element: $('#post_body').$()}
  $('head').$().appendChild mce
  if location.hash
    proceedHash location.hash.substring 1
  window.addEventListener 'hashchange', ->
    hash = location.hash.substring 1
    proceedHash hash
  buttons = $('.button').$()
  for node in buttons
    node.addEventListener 'click', (event) ->
      page = @dataset.page
      openPage page, @
  $("#delete").$().addEventListener 'click', (event) ->
    unless confirm "Are you sure you want to delete the arctile?"
      event.preventDefault()
      event.stopPropagation()
  posts = $('.post').$()
  posts = [posts] unless Array.isArray posts
  for post in posts
    post.addEventListener 'click', (event) ->
      openPage 'update_post'
      post = JSON.parse @dataset.post
      $('#post_id').$().value = post.id
      $('#post_title').$().value = post.title
      $('#post_desc').$().value = post.description
      editors['post_body'].value(post.body)
      if post.published
        $("#draft").addClass('unpublish').$().innerHTML = "Save & Unpublish"
        $("#publish").$().innerHTML = "Update"
      else
        $("#draft").removeClass('unpublish').$().innerHTML = "Save"
        $("#publish").$().innerHTML = "Save & Publish"
      