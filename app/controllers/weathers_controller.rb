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
      # APIレスポンスの確認
      if weahter_data["weather"] && weather_data["main"]
        @weather = {
          name: weather_data["name"],
          description: weather_data["weather"].first["description"],
          temp_max: weather_data["main"]["temp_max"],
          temp_min: weather_data["main"]["temp_min"],
          humidity: weather_data["main"]["humidity"],
          # todo 現在は当日分のみの取得
        }
      else 
        @error = "予期せぬレスポンスです。天気情報が取得できませんでした。"
      end
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
