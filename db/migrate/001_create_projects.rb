class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.column :name, :string
      t.column :description, :text
      t.column :started, :date
      t.column :completed, :date
    end
  end

  def self.down
    drop_table :projects
  end
end
