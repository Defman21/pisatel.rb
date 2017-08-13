module Models
  class Post < Sequel::Model
    def self.[](*ids)
      if ids.length > 1
        where(id: ids)
      else
        where(id: ids[0])
      end
    end
    
    dataset_module do
      def published
        where(published: true)
      end
    end
  end
end

module DB
  Posts = Models::Post
end