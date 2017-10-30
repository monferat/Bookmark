class Bookmarker < ApplicationRecord

  belongs_to :user

  validates :user_id, presence: true
  validates :title, presence: true, uniqueness: true, length: {in: 3..50}
  validates :url, format: {with: Regexp.new(URI::regexp(%w(http https)))}, presence: true

end
