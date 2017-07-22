class AddPreviousStateIdToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :previous_state_id, :integer
  end
end
