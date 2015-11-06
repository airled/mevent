Sequel.migration do
  change do
    create_table :concerts do
      primary_key :id
      String :name
      String :place
      String :date
      String :pic_url
    end
  end
end  
