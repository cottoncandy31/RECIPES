class Recipe < ApplicationRecord
  has_one_attached :post_image
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  belongs_to :genre
  belongs_to :price_range
  has_many :bookmarks, dependent: :destroy
  # belongs_to :price_ranges

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  #検索(ransack)のキーワード："title", "body"はrecipesテーブルの中のtitle,bodyカラムであり、"user.name"はusersテーブルの中のnameカラムである
  def self.ransackable_attributes(auth_object = nil)
    ["title", "body", "user.name", "genre.name"]
  end
  #検索キーワードが別のテーブルのカラムに存在する場合：該当するモデル名（今回はuserモデル）を記載する
  def self.ransackable_associations(auth_object = nil)
    ["user", "genre"]
  end
  #ransackのキーワード検索の中から、さらに新着順や退会済みユーザーのデータを除いた検索に絞り込んで検索したい場合の記述
  def self.ransackable_scopes(auth_object = nil)
    ["latest", "most_favorited", "published"]
  end
  
  #並べ替え(新着順/いいね順 等)
  scope :latest, -> {order(created_at: :desc)}
  scope :most_favorited, -> { includes(:favorites).sort_by { |x| x.favorites.size }.reverse }

  #退会済みのユーザのデータが会員側には表示されないよう設定
  scope :published, -> { joins(:user).where(user: { is_deleted: false}) }

  #既にブックマークしているかを検証
  def bookmarked_by?(user)
    bookmarks.where(user_id: user).exists?
  end
end
