Sequel.migration do
  change do
    create_table :posts do
      primary_key :id
        
      String    :title,       null: false
      String    :description, null: false
      String    :body,        null: false, text: true
      TrueClass :published,   null: false, default: true
    end
  end
end
