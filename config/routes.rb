PhpGenerator::Application.routes.draw do
  #root :to => 'generator#index'
  #resources :generators, :collection=>{:index => :get, :php_generator => :generator}
  #root :to =>  "generators/form"
  resources :generator  
  get "generators/download"
  get "generators/form"
  post "generators/form"
  #get "generators/show"
end
