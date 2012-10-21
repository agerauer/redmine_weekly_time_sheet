ActionController::Routing::Routes.draw do |map|
  map.resources :weekly_time_sheet
  map.connect 'weekly_time_sheet', :controller => 'weekly_time_sheet', :action => 'index'
  map.connect 'delete_item', :controller => 'weekly_time_sheet', :action => 'delete_item'
  map.connect 'project_tasks/:id', :controller => 'weekly_time_sheet', :action => 'project_tasks'
  map.connect 'submit_time', :controller => 'weekly_time_sheet', :action => 'submit_time'
end
