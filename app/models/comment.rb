class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :recipe
  scope :published, -> { joins(:user).where(user: { is_deleted: false}) }
  validates :comment, presence: true, length: { maximum: 150 }
end
