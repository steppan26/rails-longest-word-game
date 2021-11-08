Rails.application.routes.draw do
  get 'new', to: 'games#new'
  post 'score', to: 'games#score'
  root to: 'games#home'
end
