class Recipe < ApplicationRecord
  has_one_attached :post_image
  belongs_to :user
  # belongs_to :post_image
  has_many :post_comments, dependent: :destroy
 # belongs_to :genre
end
