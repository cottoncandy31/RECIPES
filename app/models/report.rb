class Report < ApplicationRecord
  belongs_to :reporter, class_name: "User"
  belongs_to :reported, class_name: "User"

  enum check: { '確認済み': 0, '未確認': 1 }

  # reporter_idがuser_idである通報の件数を返すクラスメソッド
  def self.reported_count(user_id)
    where(reported_id: user_id).count
  end
end
