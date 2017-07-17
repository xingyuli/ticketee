class AddContentTypeToAssets < ActiveRecord::Migration[5.1]
  def change
    add_column :assets, :content_type, :string
  end
end
