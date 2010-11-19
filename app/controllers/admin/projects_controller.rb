class Admin::ProjectsController < ApplicationController
  layout 'application'
  # GET /admin/projects
  # GET /admin/projects.xml
  def index
    @projects = Project.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @projects.to_xml }
    end
  end

  # GET /admin/projects/1
  # GET /admin/projects/1.xml
  def show
    @project = Admin::Project.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @project.to_xml }
    end
  end

  # GET /admin_projects/new
  def new
    @project = Project.new
  end

  # GET /admin_projects/1;edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /admin/projects
  # POST /admin/projects.xml
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to project_url(@project) }
        format.xml  { head :created, :location => admin_project_url(@project) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors.to_xml }
      end
    end
  end

  # PUT /admin/projects/1
  # PUT /admin/projects/1.xml
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to project_url(@project) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors.to_xml }
      end
    end
  end

  # DELETE /admin/projects/1
  # DELETE /admin/projects/1.xml
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.xml  { head :ok }
    end
  end
  
  def add_image
    @project = Project.find(params[:id])
    project_image = ProjectImage.new(params[:project_image])
    @project.project_images << project_image
    flash[:notice] = 'Image was successfully uploaded.'
    redirect_to edit_project_url(@project)
  end
  
  def delete_image
    project_image = ProjectImage.find(params[:image_id])
    @project = project_image.project
    project_image.destroy
    flash[:notice] = 'Image was successfully deleted.'
    redirect_to edit_project_url(@project)
  end
end
