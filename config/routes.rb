Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

   namespace :api do
     namespace :v1 do 
         resources :credit_lines
         resources :transactions 
         resources :payment_cycles 
         resources :sessions
         resources :users do 
            collection do
              post :check_email
              post :check_existed_email
            end 
         end 
      end 
   end 

  resources :credit_lines

  resources :users do
    collection do
      get :login
    end
  end

  root "pages#index"

end
