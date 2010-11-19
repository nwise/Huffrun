require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/projects_controller'

# Re-raise errors caught by the controller.
class Admin::ProjectsController; def rescue_action(e) raise e end; end

class Admin::ProjectsControllerTest < Test::Unit::TestCase
  fixtures :admin_projects

  def setup
    @controller = Admin::ProjectsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:admin_projects)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_project
    old_count = Admin::Project.count
    post :create, :project => { }
    assert_equal old_count+1, Admin::Project.count
    
    assert_redirected_to project_path(assigns(:project))
  end

  def test_should_show_project
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_project
    put :update, :id => 1, :project => { }
    assert_redirected_to project_path(assigns(:project))
  end
  
  def test_should_destroy_project
    old_count = Admin::Project.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Admin::Project.count
    
    assert_redirected_to admin_projects_path
  end
end
