Redactor2Rails::Engine.routes.draw do
  resources :images, :only => [:create, :show]
  resources :files, :only => [:create, :show]
end
