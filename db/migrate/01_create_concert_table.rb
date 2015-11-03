Sequel.migration do
  change do
    create_table :concerts do
      primary_key :id
      String :name
      String :date
    end
  end
end  