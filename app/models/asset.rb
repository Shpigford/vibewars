class Asset < ApplicationRecord
  belongs_to :collection

  def formatted_name
    self.name.blank? ? "##{self.token_id}" : self.name
  end
end
