require 'test_helper'

class ProjectUserRelationsControllerTest < ActionController::TestCase
  setup do
    @project_user_relation = project_user_relations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:project_user_relations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project_user_relation" do
    assert_difference('ProjectUserRelation.count') do
      post :create, project_user_relation: @project_user_relation.attributes
    end

    assert_redirected_to project_user_relation_path(assigns(:project_user_relation))
  end

  test "should show project_user_relation" do
    get :show, id: @project_user_relation.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project_user_relation.to_param
    assert_response :success
  end

  test "should update project_user_relation" do
    put :update, id: @project_user_relation.to_param, project_user_relation: @project_user_relation.attributes
    assert_redirected_to project_user_relation_path(assigns(:project_user_relation))
  end

  test "should destroy project_user_relation" do
    assert_difference('ProjectUserRelation.count', -1) do
      delete :destroy, id: @project_user_relation.to_param
    end

    assert_redirected_to project_user_relations_path
  end
end
