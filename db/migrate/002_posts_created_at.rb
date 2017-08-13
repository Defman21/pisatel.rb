Sequel.migration do
  up do
    add_column :posts, :created_at, Integer
    from(:posts).update created_at: Time.now.to_i
  end
  
  down do
    drop_column :posts, :created_at
  end
end
