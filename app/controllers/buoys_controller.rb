class BuoysController < ApplicationController
  # GET /buoys
  # GET /buoys.json
  def index
    @buoys = Buoy.all
    @json = @buoys.to_gmaps4rails

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @buoys }
    end
  end

  # GET /buoys/1
  # GET /buoys/1.json
  def show
    @buoy = Buoy.find(params[:id])
    @buoy_data = @buoy.buoy_datum.paginate(:page => params[:page], :per_page => 10)
    @json = @buoy.to_gmaps4rails
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @buoy }
    end
  end

  # GET /buoys/new
  # GET /buoys/new.json
  def new
    @buoy = Buoy.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @buoy }
    end
  end

  # GET /buoys/1/edit
  def edit
    @buoy = Buoy.find(params[:id])
  end

  # POST /buoys
  # POST /buoys.json
  def create
    @buoy = Buoy.new(params[:buoy])

    respond_to do |format|
      if @buoy.save
        format.html { redirect_to @buoy, notice: 'Buoy was successfully created.' }
        format.json { render json: @buoy, status: :created, location: @buoy }
      else
        format.html { render action: "new" }
        format.json { render json: @buoy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /buoys/1
  # PUT /buoys/1.json
  def update
    @buoy = Buoy.find(params[:id])

    respond_to do |format|
      if @buoy.update_attributes(params[:buoy])
        format.html { redirect_to @buoy, notice: 'Buoy was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @buoy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buoys/1
  # DELETE /buoys/1.json
  def destroy
    @buoy = Buoy.find(params[:id])
    @buoy.destroy

    respond_to do |format|
      format.html { redirect_to buoys_url }
      format.json { head :no_content }
    end
  end
end
