require "httparty"
require "uri"

class WeatherService
  include HTTParty
  base_uri "https://api.openweathermap.org/data/2.5/weather"

  def initialize(location)
    @api_key = ENV["OPENWEATHER_API_KEY"]
    @location = location
  end

  def fetch_weather
      options = {
        query: {
          q: "#{@location},jp",
          appid: @api_key,
          lang: "ja",
          units: "metric" # 摂氏
        }
      }
    seld.class.get("", options) # base_uriをどこまで切ればよいか分からない
  end
end