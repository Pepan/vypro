class AddWorkStartedAtToProject < ActiveRecord::Migration
  def change
    add_column :projects, :work_started_at, :datetime
  end
end
