Rails.application.routes.draw do
    root 'weathers#new'
    post '/weathers', to: 'weathers#create'
    get '/weathers/:id', to: 'weathers#show', as: 'weathers_show'
    # root 'application#hello'
end
