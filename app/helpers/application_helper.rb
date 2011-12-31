# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
 
  
  def project_path (project , delim = ">", as_link = false)
    res = as_link ?   step_link(project) : step_title(project)
    
    while parent project
        project = project.parent
        res = (as_link ? step_link(project): step_title(project)) + delim + res
    end
 
    res
  end
  
  def step_link (step , truncate_length = 3)
    link_to step_title(step ,truncate_length), step_path(step) , :title => step.title
  end
  
  def step_breadcrumb (step, delim = "&gt;", bc = "")
       project_path(step,delim,true) +delim + bc
  end
  
  def next_status_link (project, type = '')
    # call promote only if not last (-1)
     status_link( :icon => "right",
                  :icon_type => type,
                  :project => project, 
                  :action => 'promote',
                  :except => [-1,2]){|status|next_status(status)}
    
  end
  
  
  def prev_status_link (project, type='')
    # call de mote only if not first (0)
     status_link( :icon => "left",
                  :icon_type => type,
                  :project => project, 
                  :action => 'demote',
                  :except => [0]){|status|prev_status(status)}
  end
 
 # ~!~ need to make this a form! and POST!
 # img, project, action, unless_index
 def status_link (options = {})
    # we don't want to show next/prev links if there are children / the options state "except"
    return if !options[:project].children.blank? || (!options[:except].nil? && options[:except].include?(Step::Status.index(_status options[:project])))
   link_to(image_tag("icons/#{options[:icon]}#{options[:icon_type]}.png",
                     :title=>yield(_status(options[:project]))), 
              :controller => 'manager', 
              :action=> options[:action], 
              :id => options[:project].id) #link_to 
              
 end
 
 def next_status(status)
    return Step::Status[status_index(status) + 1]
 end
 
 def prev_status(status)
  return Step::Status[status_index(status) -1]  
 
 end
     
   
 
  def status_index(status)
    Step::Status.each_with_index do |element, idx|  
      if (element.eql? status)
        return idx;
      end
    end
  end
  
  
  def printable?
    a = params[:action] 
    a == 'show' ||
    a == 'search'
    
  end

  protected
  
  def mode_print? 
    params[:mode] == 'print'
  end
  
  
  private 
  

  def snippet(thought, wordcount)
    wordcount == 0 ? thought : thought.split[0..(wordcount-1)].join(" ") +(thought.split.size.abs > wordcount.abs ? "..." : "") 
  end
  
  def step_title (step , length = 3)
    snippet(step.title,length)
  end
  
  def parent (step)
    step.parent
  end
  
  def _status (step)
    step.status
  end
end
