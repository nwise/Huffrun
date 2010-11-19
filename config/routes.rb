ActionController::Routing::Routes.draw do |map|
  map.resources :projects,
                :path_prefix => '/admin',
                :controller => 'admin/projects', 
                :member => { :add_image => :any }
              
  map.sitemap 'sitemap.xml', :controller => 'sitemap', :action => 'sitemap'                
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
  map.delete_project_image 'admin/projects/:id/delete_image/:image_id',
                :path_prefix => '/admin',
                :controller => 'admin/projects',
                :action => 'delete_image'

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
