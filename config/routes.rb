OrderManagementApi::Application.routes.draw do

  resources :line_items, except: [:new, :edit]
  resources :orders,     except: [:new, :edit, :delete]
  resources :products,   except: [:new, :edit]
end