Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

   namespace :api do
     namespace :v1 do 
         resources :credit_lines
         resources :transactions 
         resources :payment_cycles 
      end 
   end 




  root "pages#index"

end
