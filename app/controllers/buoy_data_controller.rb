class BuoyDataController < ApplicationController
  # GET /buoy_data
  # GET /buoy_data.json
  def index
    @buoy_data = BuoyDatum.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @buoy_data }
    end
  end

  # GET /buoy_data/1
  # GET /buoy_data/1.json
  def show
    @buoy_datum = BuoyDatum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @buoy_datum }
    end
  end

  # GET /buoy_data/new
  # GET /buoy_data/new.json
  def new
    @buoy_datum = BuoyDatum.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @buoy_datum }
    end
  end

  # GET /buoy_data/1/edit
  def edit
    @buoy_datum = BuoyDatum.find(params[:id])
  end

  # POST /buoy_data
  # POST /buoy_data.json
  def create
    @buoy_datum = BuoyDatum.new(params[:buoy_datum])

    respond_to do |format|
      if @buoy_datum.save
        format.html { redirect_to @buoy_datum, notice: 'Buoy datum was successfully created.' }
        format.json { render json: @buoy_datum, status: :created, location: @buoy_datum }
      else
        format.html { render action: "new" }
        format.json { render json: @buoy_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /buoy_data/1
  # PUT /buoy_data/1.json
  def update
    @buoy_datum = BuoyDatum.find(params[:id])

    respond_to do |format|
      if @buoy_datum.update_attributes(params[:buoy_datum])
        format.html { redirect_to @buoy_datum, notice: 'Buoy datum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @buoy_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buoy_data/1
  # DELETE /buoy_data/1.json
  def destroy
    @buoy_datum = BuoyDatum.find(params[:id])
    @buoy_datum.destroy

    respond_to do |format|
      format.html { redirect_to buoy_data_url }
      format.json { head :no_content }
    end
  end
end
