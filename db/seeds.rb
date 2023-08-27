# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#モデル.find_or_create_by!(条件, ブロック引数):存在しないものは新しく作成、既に存在する場合は既存のレコードを取得
Admin.find_or_create_by!(email: 'recipes@example.com') do |admin|
  admin.password = 'dwc_recipes'
end

Genre.find_or_create_by!(name: 'ごはんもの')
Genre.find_or_create_by!(name: '麺類')
Genre.find_or_create_by!(name: 'パスタ')
Genre.find_or_create_by!(name: 'グラタン')
Genre.find_or_create_by!(name: 'サラダ')
Genre.find_or_create_by!(name: '汁物・スープ')
Genre.find_or_create_by!(name: '野菜のおかず')
Genre.find_or_create_by!(name: 'お肉のおかず')
Genre.find_or_create_by!(name: '粉もの')
Genre.find_or_create_by!(name: '鍋もの')
Genre.find_or_create_by!(name: '揚げ物')
Genre.find_or_create_by!(name: 'スイーツ')
Genre.find_or_create_by!(name: 'ソース・ドレッシング')

PriceRange.find_or_create_by!(minimum_price: 0, maximum_price: 100, name: '～100円')
PriceRange.find_or_create_by!(minimum_price: 100, maximum_price: 200, name: '100～200円')
PriceRange.find_or_create_by!(minimum_price: 200, maximum_price: 300, name: '200～300円')
PriceRange.find_or_create_by!(minimum_price: 300, maximum_price: 400, name: '300～400円')

