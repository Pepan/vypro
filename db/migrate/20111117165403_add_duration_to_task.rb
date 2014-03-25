class AddDurationToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :duration_best_id, :integer
    add_column :tasks, :duration_worst_id, :integer
  end
end
