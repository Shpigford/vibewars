class Asset < ApplicationRecord
  belongs_to :collection
  has_one :ranking

  def formatted_name
    self.name.blank? ? "##{self.token_id}" : self.name
  end
end
