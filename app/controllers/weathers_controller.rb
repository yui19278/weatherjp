require "httparty"
require "uri"

class WeathersController < ApplicationController
  def new
  end

  def show
    @location = params[:location]
    # WeatherServiceを呼び出して天気情報を取得
    response = WeatherService.new(@location).fetch_weather
    
    if response.success?
      weather_data = response.parsed_response
      @weather = {
        name: weather_data["name"],
        description: weather_data["weather"].first["description"],
        temp_max: weather_data["main"]["temp_max"],
        temp_min: weather_data["main"]["temp_min"],
        humidity: weather_data["main"]["humidity"],
      }
    else 
      @error = "天気情報の取得に失敗しました。地域名を確認してください。"
    end
  end

  private
  def validate_location
    if params[:location].blank?
      flash[:alert] = "入力が不正です。"
      redirect_to root_path
    end
end

class WeatherService
  include httparty
  base_uri "https://api.openweathermap.org/data/2.5/weather"

  def initialize(location)
    api_key = ENV["OPENWEATHER_API_KEY"]
    @options = {
      query: {
        q: "#{location},jp",
        appid: api_key,
        lang: "ja",
      }
    }
  end

  def fetch_weather
    seld.class.get("", @options)
  end
end
