PhpGenerator::Application.routes.draw do
  #root :to => 'generator#index'
  #resources :generators, :collection=>{:index => :get, :php_generator => :generator}
  resources :generators  
end
