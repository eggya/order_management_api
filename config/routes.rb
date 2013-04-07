OrderManagementApi::Application.routes.draw do

  resources :products, except: [:new, :edit]
end