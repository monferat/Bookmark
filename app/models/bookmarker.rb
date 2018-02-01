class Bookmarker < ApplicationRecord
  include PgSearch

  has_attached_file :snapshot, styles: { medium: '200x200>' }, default_url: '/images/missing.png'
  validates_attachment :snapshot, content_type: { content_type: %w[image/jpg image/jpeg image/png] }

  belongs_to :user

  validates :user_id, presence: true
  validates :title, presence: true, uniqueness: true, length: { in: 3..50 }
  validates :url, format: { with: Regexp.new(URI.regexp(%w[http https])) }, presence: true

  default_scope { order(created_at: :desc) }

  pg_search_scope :search_by_title_and_url, against: %i[title url],
                                            using: {
                                              tsearch: {
                                                prefix: true,
                                                any_word: true
                                              }
                                            }
end
