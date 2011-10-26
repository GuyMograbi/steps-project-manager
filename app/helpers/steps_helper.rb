module StepsHelper
 
  def access_description(step)
        
        step.inherits_access? ? 
        "#{step.resolved_access} (from #{step.access_resolver}) " : 
        "#{step.resolved_access}"
  end
  
  
  def title_truncate 
    title_truncate? ? 6 : 0
  end
  
  
  def title_truncate?
    return !mode_print? 
  end
  
end
