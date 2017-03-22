class Apartment < ApplicationRecord
  validates :number,      presence: true, uniqueness: true
  validates :floorplan,   presence: true
  validates :price_range, presence: true
  validates :url,         presence: true

  def message
    %(
      There is a new apartment available!
      Apt ##{number} (#{floorplan})
      Price: #{price_range}
      #{url}
    )
  end
end
