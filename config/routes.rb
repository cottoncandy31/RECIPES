Rails.application.routes.draw do
  #ゲストログインのためのルーティングを設定
  devise_scope :user do
    post "users/guest_sign_in", to: "public/sessions#guest_sign_in"
  end

  # 会員用
  # もともとのdeviseにあったファイル名をpublics→publicに変更し、それに伴って
  #app/views/public/sessions/new.html.erb内で、<%= render "public/shared/links" %>に変更
  # また、<%= render "public/shared/error_messages", resource: resource %>に変更したため下記に変更点を記載している
  # URL /customers/sign_in ...
  devise_for :users, controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # 管理者用
  # もともとのdeviseにあったファイル名をadmins→adminに変更し、それに伴って
  #app/views/admin/sessions/new.html.erb内で、<%= render "admin/shared/links" %>に変更したため、下記に変更点を記載している
  # URL /admin/sign_in ...
  devise_for :admin, controllers: {
    sessions: "admin/sessions"
  }
  root to:'public/homes#top'
    # #データを追加(保存)するためのルーティング
    # post 'recipes' => 'recipes#create'

  namespace :admin do
    #deviseに管理者ログアウトのアクションに対応するルートを追加(devise_scopeを用いてネストさせる)
    devise_scope :admin do
      get '/sign_out', to: 'sessions#destroy'
    end
    resources :users, only: [:index, :show, :update] do
      # ユーザー検索のルーティングを追加
      get '/users', to: 'users#index'
    end
    resources :recipes, only: [:index, :show, :update] do
      resources :comments, only: [:update]
    end
  end
  #deviseでもともと設定されているので削除
  # namespace :admin do
  #   resources :sessions, only: [:new, :create, :destroy]
  # end
  namespace :public do
    resources :users, only: [:show, :index, :edit, :update, :destroy] do
       resources :recipes, only: [:destroy]
      #今回、userコントローラー内にcheckアクションとrecipesアクションを追加している。
      #その際にURLを/:user_id/ではなく他のuserコントローラー内のアクションのパスと同様に/:id/としたいので、member do…endで囲っている
      member do
        get 'check'
        get 'recipes'
        get 'followings'
        get 'followers'
      end
      #フォロー・フォロワー機能のためのルーティング
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
      resources :bookmarked_recipes, only: [:index]
    end
    resources :recipes, except: [:destroy] do
      resources :comments, only: [:create, :edit, :update, :destroy]
      resource :favorites, only: [:create, :destroy]
      resource :bookmarks, only: [:create, :index, :show, :destroy]
    end
  end
  #deviseでもともと設定されているので削除
  # namespace :public do
  #   resources :registrations, only: [:new, :create]
  # end
  # # namespace :public do
  # #   resources :sessions, only: [:new, :create]
  # end
  # # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
