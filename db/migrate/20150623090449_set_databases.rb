class SetDatabases < ActiveRecord::Migration
  def change
    create_table :job_list do |t|
      t.string :slug
      t.string :label
      t.string :code_rome
      t.integer :id_key
    end
  end
end
