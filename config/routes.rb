Rails.application.routes.draw do
  
  get 'foods/index' => 'foods#index'
  get 'foods/new' => 'foods#new'
  post 'foods/create' => 'foods#create'
  get 'foods/:id/check' => 'foods#check'
  post 'foods/:id/save' => 'foods#save'
  
  get 'users/index' => 'users#index'
  get 'users/new' => 'users#new'
  post 'users/create' => 'users#create'
  get 'users/:id/choose' => 'users#choose'
  post 'users/:id/eat' => 'users#eat'
  get 'users/:id/edit' => 'users#edit'
  post 'users/:id/update' => 'users#update'
  get 'users/:id/set' => 'users#set'
  post 'users/:id/input' => 'users#input'
  get 'users/:id/share' => 'users#share'
  
  get 'options' => 'options#index'
  get 'options/new' => 'options#new'
  post 'options/create' => 'options#create'

  get '/' => 'home#top'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
