require 'faraday'
require "faraday/retry"

class WeathersService
  def call
    # todo 後で下の内容をcallに移動
  end

  def initialize()
    @api_key = ENV["OPENWEATHER_API_KEY"]
    # Faradayの接続設定
    @connection = Faraday.new(url:  "https://api.openweathermap.org") do |f|
        f.request  :retry, max: 2, interval: 0.2, backoff_factor: 2, retry_statuses: [429, 500, 502, 503, 504]
        f.response :json, :content_type => /\bjson$/ # 正規表現でparse
        f.adapter Faraday.default_adapter
    end
  end

  # 現在の天気
  def fetch_weather(location)
    @connection.get("/data/2.5/weather") do |req|
      req.params[:q] = "#{location},jp"
      req.params[:appid] = @api_key
      req.params[:lang] = "ja"
      req.params[:units] = "metric" # 摂氏
    end
  end
end