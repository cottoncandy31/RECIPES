class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :recipe
  #ロード中に２度以上連続で登録しようとすることを防ぐため、下記にvalidatesを追加
  validates :user_id, uniqueness: { scope: :recipe_id }
end
