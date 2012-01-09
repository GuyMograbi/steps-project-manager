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
 
  def can_demote?(project)
    !project.children? && !project.new?
  end

  def can_promote?(project)
    !project.children? && !project.completed? 
  end

  def next_promote_status(project)
    Step::Status[Step::Status.index(project.status) + 1]
  end

  def next_demote_status(project)
    Step::Status[Step::Status.index(project.status) - 1]  
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
