class ProjectsController < ApplicationController
  layout 'application'

  def index
    @projects = Project.find(:all)
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(params[:project])
    if @project.save
      flash[:notice] = 'Project was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end


end
