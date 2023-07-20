class Recipe < ApplicationRecord
  has_one_attached :post_image
  has_many_attached :step_images
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  belongs_to :genre
  belongs_to :price_range
  has_many :bookmarks, dependent: :destroy
  has_many :ingredients, inverse_of: :recipe, dependent: :destroy
  accepts_nested_attributes_for :ingredients, allow_destroy: true
  # belongs_to :price_ranges

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  #検索(ransack)のキーワード："title", "body"はrecipesテーブルの中のtitle,bodyカラムであり、"user.name"はusersテーブルの中のnameカラムである
  def self.ransackable_attributes(auth_object = nil)
    ["title", "body", "user.name", "genre.name", "genre_id", "price_range_id"]
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
    bookmarks.where(user_id: user.id).exists?
  end

  # 材料と分量を組み合わせた配列を返すメソッド
  def ingredients_and_quantities
    ingredients_array = self.ingredients.split("\n")
    quantities_array = self.quantities.split("\n")
    result = []

    # 材料と分量を組み合わせて配列に格納
    ingredients_array.each_with_index do |ingredient, index|
      quantity = quantities_array[index] || "" # 分量が存在しない場合は空文字をセット
      result << { ingredient: ingredient, quantity: quantity }
    end

    result
  end

  # 調理工程を配列に分割して返すメソッド
  def step_images_array
    step_images.map do |image|
      Rails.application.routes.url_helpers.rails_representation_url(
        image.variant(resize: "100x100").processed, only_path: true
      )
    end
  end

  def steps_array
    steps.split("\n")
  end
  
  # validates :ingredients, presence: true
end
