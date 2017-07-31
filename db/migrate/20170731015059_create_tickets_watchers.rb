class CreateTicketsWatchers < ActiveRecord::Migration[5.1]
  def change
    create_table :tickets_watchers, id: false do |t|
      t.integer :user_id, :ticket_id
    end
  end
end
