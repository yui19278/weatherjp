class WeathersController < ApplicationController
    # get /
    def new
        @history = history_list
        @weather = Weather.new
    end
    # post /weathers
    def create
        flash[:notice] = "天気を取得しました"
    end
end

