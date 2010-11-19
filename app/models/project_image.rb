class ProjectImage < Image
  
  belongs_to :project, :dependent => :destroy
  acts_as_list :scope => :project_id
  
end