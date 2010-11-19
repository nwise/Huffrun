class RemoveStartedFromProjects < ActiveRecord::Migration
  def self.up
    remove_column :projects, :started
    add_column :projects, :construction_cost, :decimal, :precision => 20, :scale => 2
  end

  def self.down
    add_column :projects, :started, :date
    remove_column :projects, :construction_cost
  end
end
