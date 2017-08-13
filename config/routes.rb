Rails.application.routes.draw do
  
  devise_for :users
  
  root to: 'welcome#index'
  
  get 'welcome/chat'
  
  get 'welcome/index'

  post 'welcome/message'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
