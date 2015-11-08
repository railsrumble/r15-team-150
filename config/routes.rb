Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  post '/files' => "home#get_files"
  post '/download' => "home#download"

end
