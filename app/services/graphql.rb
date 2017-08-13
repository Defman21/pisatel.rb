#class RecordLoader < GraphQL::Batch::Loader
#  def initialize(model)
#    @model = model
#  end
#  
#  def perform(ids)
#    _ids = ids
#    ids = ids[0] if ids.length == 1
#    @model.published.where(id: ids).each { |record| fulfill record.id, record }
#    _ids.each { |id| fulfill(id, nil) unless fulfilled? id }
#  end
#end

PostType = GraphQL::ObjectType.define do
  name "Post"
  description "A blog post"

  field :id, !types.Int
  field :title, !types.String
  field :description, !types.String
  field :body, !types.String
  field :published, !types.Boolean
  field :created_at, !types.Int
end

MutationType = GraphQL::ObjectType.define do
  name "Mutation"
  description "The query mutation of this schema"
  
  field :addPost do
    type PostType
    argument :post, PostInputType
    description "Adds a Post"
    
    resolve ->(obj, args, ctx) {
      data = {
        created_at: Time.now.to_i
      }.merge args['post'].to_h
      id = DB::Posts.insert(data)
      DB::Posts.where(id: id).first
    }
  end
  
  field :updatePost do
    type PostType
    argument :id, !types.Int
    argument :post, PostInputType
    description "Updates a Post"
    
    resolve ->(obj, args, ctx) {
      data = {
        id: args['id'],
        created_at: Time.now.to_i
      }.merge args['post'].to_h
      id = DB::Posts[data[:id]].update(data)
      DB::Posts.where(id: id).first
    }
  end
  
  field :deletePost do
    type types.Int
    argument :id, !types.Int
    description "Deletes a Post"
    
    resolve ->(obj, args, ctx) {
      DB::Posts[args['id']].delete
    }
  end
end

PostInputType = GraphQL::InputObjectType.define do
  name "PostInputType"
  
  argument :title, !types.String
  argument :description, !types.String
  argument :body, !types.String
  argument :published, !types.Boolean
end

QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The query root of this schema"

  field :post do
    type PostType
    argument :id, !types.Int
    description "Find a Post by ID"
    resolve ->(obj, args, ctx) {
      #RecordLoader.for(DB::Posts).load args['id']
      DB::Posts.where(id: args['id']).first
    }
  end
  field :posts do
    type types[PostType]
    argument :limit, types.Int, default_value: 9
    argument :after, types.Int, default_value: 0
    argument :all, types.Boolean, default_value: false
    description "Find all posts"
    resolve ->(obj, args, ctx) {
      if args[:all]
        return DB::Posts.order(Sequel.desc(:created_at)).all
      end
      DB::Posts.published.limit(args[:limit], args[:after]).order(Sequel.desc(:created_at)).all
    }
  end
end

class GraphQLError < StandardError
  def initialize(data)
    message = data['message']
    locations = data['locations']
    error = message
    locations.each do |location|
      error += " at #{location['line']}:#{location['column']}"
    end
    super error
  end
end

Schema = GraphQL::Schema.define do
  query QueryType
  mutation MutationType
  
  use GraphQL::Batch
end

class GraphQLService
  def self.query(key, query, variables = {})
    Logging::Logger.debug "GraphQL query: #{query}"
    Logging::Logger.debug "GraphQL variables: #{variables}"
    query = Schema.execute query, variables: variables
    if query['errors']
      query['errors'].each do |error|
        raise GraphQLError.new error
      end
    else
      query['data'][key]
    end
  end
end
