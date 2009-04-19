require 'redmine'

Redmine::Plugin.register :redmine_weekly_time_sheet do
  name 'Redmine Weekly Time Sheet'
  author 'Andreas Gerauer'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  
  menu(:top_menu,
       :weekly_time_sheet,
       {:controller => 'weekly_time_sheet ', :action => 'index'},
       :caption => :redmine_weekly_time_sheet_title,
       :if => Proc.new {
         User.current.allowed_to?(:log_time, nil, :global => true) ||
         User.current.admin?
       }
   )
end
