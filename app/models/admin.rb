class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
  #管理者側の新規登録は不要のため削除 :registerable,
         :recoverable, :rememberable, :validatable
end
