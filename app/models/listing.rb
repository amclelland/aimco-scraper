class Listing < ApplicationRecord
  validates :pid, presence: true, uniqueness: true
  validates :url, presence: true

  def message
    %(
      New Craigslist listing:
      #{url}
    )
  end
end
