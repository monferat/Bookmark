class Bookmarker < ApplicationRecord

  has_attached_file :snapshot, styles: { medium: "300x300#"}, default_url: "/images/missing.png"
  # has_attached_file :snapshot, :storage => :s3,
  # :s3_credentials => "#{Rails.root}/config/s3.yml"
  validates_attachment_content_type :snapshot, content_type: /\Aimage\/.*\z/

  belongs_to :user

  validates :user_id, presence: true
  validates :title, presence: true, uniqueness: true, length: {in: 3..50}
  validates :url, format: {with: Regexp.new(URI::regexp(%w(http https)))}, presence: true

end
