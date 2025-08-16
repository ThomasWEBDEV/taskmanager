class AddPriorityToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :priority, :string
  end
end
