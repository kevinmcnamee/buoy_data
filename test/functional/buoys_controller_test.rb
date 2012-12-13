require 'test_helper'

class BuoysControllerTest < ActionController::TestCase
  setup do
    @buoy = buoys(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:buoys)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create buoy" do
    assert_difference('Buoy.count') do
      post :create, buoy: { coordinates: @buoy.coordinates, name: @buoy.name }
    end

    assert_redirected_to buoy_path(assigns(:buoy))
  end

  test "should show buoy" do
    get :show, id: @buoy
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @buoy
    assert_response :success
  end

  test "should update buoy" do
    put :update, id: @buoy, buoy: { coordinates: @buoy.coordinates, name: @buoy.name }
    assert_redirected_to buoy_path(assigns(:buoy))
  end

  test "should destroy buoy" do
    assert_difference('Buoy.count', -1) do
      delete :destroy, id: @buoy
    end

    assert_redirected_to buoys_path
  end
end
