Rails.application.routes.draw do
  # 検索画面
  root "weather#new"
  # 検索地域画面
  get "/weather", to: "weather#show"
end