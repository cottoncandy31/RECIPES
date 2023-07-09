class Recipe < ApplicationRecord
  has_one_attached :post_image
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  belongs_to :genre
  # belongs_to :price_ranges
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end
