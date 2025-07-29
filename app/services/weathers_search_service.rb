# 成功判定から整形まで
class WeathersSearchService
    Result = Struct.new(:scucess, :weather)
    def success?
      scucess
    end

    def initialize(location)
      @location = location
      @response = WeathersService.new(location)
    end

    def call(location) 
        if @response.success?
            weather_data = @response.body
            weather_data = JSON.parse(weather_data) if weather_data.is_a?(String)
            if weather_data["weather"] && weather_data["main"]
                Result.new(true, {
                    name: weather_data["name"],
                    description: weather_data["weather"].first["description"],
                    temp_max: weather_data["main"]["temp_max"],
                    temp_min: weather_data["main"]["temp_min"],
                    humidity: weather_data["main"]["humidity"],
                })
            else
                Result.new(false, "予期せぬレスポンスです。天気情報が取得できませんでした。")
            end
        else
            Result.new(false, "天気情報の取得に失敗しました。地域名を確認してください。")
        end
    end
    private
        def load_histories
            token = cookies.signed[:user_token]
            @histories = 
            if token.present?
                SearchHistory.where(user_token: token).recent
            else
                []
            end
        end
    end
end