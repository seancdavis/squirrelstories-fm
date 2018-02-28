Rails.application.routes.draw do

  scope '__utils' do
    post 'bust_cache' => 'utilities#bust_cache'
  end

  resources :episodes, only: %i[index show]
  resources :quotes, only: %i[index]
  get 'quotes/:episode_id/:id' => 'quotes#show', as: 'quote'

  get ':slug' => 'pages#show', as: 'page'

  root to: 'pages#home'

end
