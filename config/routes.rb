Rails.application.routes.draw do
  # 検索画面
  root "weathers#new"
  # 検索地域画面
  get "/weathers", to: "weathers#index", as: "weathers" # as: :weathersよりweathers_pathが生成される？
end