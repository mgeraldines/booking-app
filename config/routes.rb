Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do 
      resources :reservations
      resources :guestsss
    end
  end
end
