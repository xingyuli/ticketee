class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include ActiveModel::Serializers::Xml
end
