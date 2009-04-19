class WeeklyTimeSheetController < ApplicationController
  unloadable
  layout 'base'
  helper :all
  
  def index
    @entries = entries_for(User.current, display_date)
    @entry = TimeEntry.new(:spent_on => display_date)
  end
  
  def project_tasks
    Issue.visible_by(User.current) do
      ret = Issue.open.find(:all, :conditions => ["#{IssueStatus.table_name}.is_closed = ?", false], :include => :status).collect do |issue|
        "<option value=\"#{issue.id}\">#{issue.to_s}</option>"
      end.join("\n")
    
      render :text => ret
    end
  end
  
  def submit_time
    entry = TimeEntry.new(:user => User.current)
    unless params[:entry][:id].blank?
      entry = TimeEntry.find(params[:entry][:id])
    end
    
    if entry.update_attributes(params[:entry])
      render_entry_list(entry.spent_on)    
    else
      render :xml => entry.errors, :status => 403
    end
  end
  
  def delete_item
    entry = TimeEntry.find(params[:id])
    if entry.editable_by?(User.current)
      entry.destroy
    end
    render_entry_list(entry.spent_on)
  end
  
  def render_entry_list(date)
    @entries = entries_for(User.current, date)
    render :partial => 'entries'
  end

  helper_method :display_date, :display_first_day_of_week, :last_week, :next_week
  def display_date
    @display_date ||= if params[:day] and params[:month] and params[:year]
      Date.civil(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    else
      Date.today
    end
  end
  
  def display_first_day_of_week
    @display_first_day_of_week = begin
      days_to_subtract = (display_date.wday - 1) % 7
      display_date - days_to_subtract
    end
  end
  
  def last_week
    display_first_day_of_week - 7
  end
  
  def next_week
    display_first_day_of_week + 7
  end
  
  def entries_for(user, date)
    TimeEntry.find(:all, :conditions => {
      :spent_on => date,
      :user_id => user.id
    },
    :order => 'project_id, issue_id',
    :include => [:project, :issue])
  end
end
