class Recipe < ApplicationRecord
  has_one_attached :post_image
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  belongs_to :genre
  has_many :bookmarks, dependent: :destroy
  # belongs_to :price_ranges
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  #並べ替え(新着順/古い順/いいね順 等)
  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  scope :most_favorited, -> { includes(:favorites).sort_by { |x| x.favorites.size }.reverse }
  
  #退会済みのユーザのデータが会員側には表示されないよう設定
  scope :published, -> { joins(:user).where(user: { is_deleted: false}) }
  
  #既にブックマークしているかを検証
  def bookmarked_by?(user)
    bookmarks.where(user_id: user).exists?
  end
end
