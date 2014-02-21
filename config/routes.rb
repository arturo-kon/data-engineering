LSUpload::Application.routes.draw do
  resources :imports, only: [:create]
  root 'imports#index'
end
