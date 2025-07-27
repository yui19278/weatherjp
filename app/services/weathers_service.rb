require 'faraday'

class WeathersService
  def call
    # todo 後で下の内容をcallに移動
  end

  def initialize()
    @api_key = ENV["OPENWEATHER_API_KEY"]
    @connection = Faraday.new(url:  "https://api.openweathermap.org")
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