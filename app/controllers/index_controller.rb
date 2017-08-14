class IndexController < ApplicationController
  get '/' do
    @site = settings.site
    @posts = GraphQLService.query 'posts', %|
query {
  posts(limit: #{@site['posts']['per_page']}) {
    id
    title
    description
  }
}
|
    haml :'index/index', layout: :application
  end

  get '/posts/:id' do |id|
    @site = settings.site
    @post = GraphQLService.query 'post', %|
query {
  post(id: #{id}) {
    title
    body
    description
  }
}
|
    if @post.nil?
      @id = id
    else
      @post['body'] = MD.render @post['body']
    end
    haml :'index/post', layout: :application
  end

  get '/pages/:page' do |page|
    page
  end
  
  get '/graphql/:query_key/:query/:variables' do |query_key, query, variables|
    redirect('/') if settings.site['endpoints']['graphql']['type'] != 'public'
    vars_hash = {}
    variables.split(',').each do |item|
      key, value = item.split '='
      key, type = key.split ':'
      unless type.nil?
        value = value.public_send "to_#{type}"
      end
      vars_hash[key] = value
    end
    json GraphQLService.query query_key, query, vars_hash
  end
end