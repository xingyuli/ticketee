class Asset < ApplicationRecord
  before_save :update_content_type

  mount_uploader :asset, AssetUploader

  belongs_to :ticket

  private

  def update_content_type
    if asset.present? && asset_changed?
      self.content_type = asset.file.content_type
    end
  end

end
