class AdminController < ApplicationController
  get '/' do
    @site = settings.site
    @is_admin = session['is_admin']
    @stylesheets = %w(admin)
    @javascripts = %w(admin)
    @posts = GraphQLService.query 'posts', %|
query {
  posts(all: true) {
    id
    title
    description
    body
    published
  }
}
|
    haml :'admin/index', layout: :application
  end
  
  post '/auth' do
    auth_data = settings.site['admin']
    if params['login'] == auth_data['login'] && \
       params['password'] == auth_data['password']
      session['is_admin'] = true
    end
    redirect '/admin'
  end
  
  before '/posts/*' do
    unless session['is_admin']
      redirect '/admin'
    end
  end
  
  post '/posts/new' do
    if params['published'] == 'true'
      params['published'] = true
    else
      params['published'] = false
    end
    GraphQLService.query 'addPost', %|
mutation addPost($post: PostInputType!) {
  addPost(post: $post) {
    id
    title
    description
    body
    published
  }
}
|, {'post' => params}
    redirect '/admin#page=posts'
  end
  
  post '/posts/update' do
    id = params.delete('id').to_i
    unless params['delete'].nil?
      GraphQLService.query 'deletePost', %|
mutation deletePost($id: Int!) {
  deletePost(id: $id) {}
}
|, {'id' => id}
      redirect '/admin#page=posts'
    else
      if params['published'] == 'true'
        params['published'] = true
      else
        params['published'] = false
      end
      GraphQLService.query 'updatePost', %|
mutation updatePost($id: Int!, $post: PostInputType!) {
  updatePost(id: $id, post: $post) {
    id
    title
    description
    body
    published
  }
}
|, {'id' => id, 'post' => params}
      redirect '/admin#page=posts'
    end
  end
end