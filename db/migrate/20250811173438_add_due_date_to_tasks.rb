class AddDueDateToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :due_date, :date
  end
end
