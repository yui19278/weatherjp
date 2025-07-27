class WeathersController < ApplicationController 
  def new
  end

  def index
    # 空白検索時はリダイレクト
    return if params[:location].blank?

    @location = params[:location]
    # WeatherServiceを呼び出して天気情報を取得
    response = WeathersService.new.fetch_weather(@location)

    # debug log表示
    Rails.logger.debug "===== OpenWeatherMap Response START ====="
    Rails.logger.debug response.body # 生のレスポンスボディを確認
    Rails.logger.debug "===== OpenWeatherMap Response END ====="
    Rails.logger.info "OWM status=#{response.status} ct=#{response.headers['content-type']} body.class=#{response.body.class}"
    Rails.logger.info "Faraday v#{Faraday::VERSION}"
    
    if response.success?
      weather_data = response.body 
      # string→json変換御まじない
      weather_data = JSON.parse(weather_data) if weather_data.is_a?(String)
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
  
end