require 'test_helper'

class BuoyDataControllerTest < ActionController::TestCase
  setup do
    @buoy_datum = buoy_data(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:buoy_data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create buoy_datum" do
    assert_difference('BuoyDatum.count') do
      post :create, buoy_datum: { buoy_id: @buoy_datum.buoy_id, swell_direction: @buoy_datum.swell_direction, swell_period: @buoy_datum.swell_period, water_temp: @buoy_datum.water_temp, wave_height: @buoy_datum.wave_height, wind_direction: @buoy_datum.wind_direction }
    end

    assert_redirected_to buoy_datum_path(assigns(:buoy_datum))
  end

  test "should show buoy_datum" do
    get :show, id: @buoy_datum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @buoy_datum
    assert_response :success
  end

  test "should update buoy_datum" do
    put :update, id: @buoy_datum, buoy_datum: { buoy_id: @buoy_datum.buoy_id, swell_direction: @buoy_datum.swell_direction, swell_period: @buoy_datum.swell_period, water_temp: @buoy_datum.water_temp, wave_height: @buoy_datum.wave_height, wind_direction: @buoy_datum.wind_direction }
    assert_redirected_to buoy_datum_path(assigns(:buoy_datum))
  end

  test "should destroy buoy_datum" do
    assert_difference('BuoyDatum.count', -1) do
      delete :destroy, id: @buoy_datum
    end

    assert_redirected_to buoy_data_path
  end
end
