class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.string :name
    end

    create_table :tags_tickets, id: false do |t|
      t.integer :tag_id
      t.integer :ticket_id
    end
  end
end