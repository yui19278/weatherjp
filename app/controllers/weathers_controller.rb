class WeathersController < ApplicationController 
  # indexで空白エラーを先に通知 
  before_action :validate_location, only: [:index]
  def new
  end

  def index
    @location = params[:location]
    # WeatherServiceを呼び出して天気情報を取得
    response = WeathersService.new.fetch_weather(@location)
    
    if response.success?
      weather_data = response.parsed_response
      # APIレスポンスの確認
      if weather_data["weather"] && weather_data["main"]
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
      flash[:alert] = "地域名を入力してください。"
      redirect_to root_path
    end
  end
end