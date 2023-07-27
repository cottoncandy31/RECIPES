class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :recipe
  #退会済みのユーザのデータが会員側には表示されないよう設定
  scope :published, -> { joins(:user).where(user: { is_deleted: false}) }
  validates :comment, presence: true, length: { maximum: 350 }
end
