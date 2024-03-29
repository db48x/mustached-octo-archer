class CallsController < ApplicationController
  # GET /calls
  # GET /calls.json
  def index
    @calls = Call.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @calls }
    end
  end

  # GET /calls/recent
  # GET /calls/recent.json
  def recent
    @calls = Call.where("audio_id IS NOT NULL").order("start ASC").limit(50).map do |call|
      { :id => call.id,
        :start => call.start,
        :end => call.end,
        :frequency => call.frequency,
        :group_full_name => call.group.full_name,
        :group_name => call.group.name }
    end
    
    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @calls }
    end
  end

  # GET /calls/1
  # GET /calls/1.json
  def show
    @call = Call.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @call }
      format.oga {
        if @call.audio
          send_file @call.audio.data.path, :type => @call.audio.data_content_type, :disposition => 'inline'
        else
          redirect_to :status => 404
        end
      }
    end
  end

  # GET /calls/new
  # GET /calls/new.json
  def new
    @call = Call.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @call }
    end
  end

  # GET /calls/1/edit
  def edit
    @call = Call.find(params[:id])
  end

  # POST /calls
  # POST /calls.json
  def create
    @audio = Audio.new(params[:audio])
    @call = Call.new(params[:call])
    @audio.call = @call
    @call.audio = @audio

    respond_to do |format|
      if @audio.save && @call.save
        format.html { redirect_to @call, notice: 'Call was successfully created.' }
        format.json { render json: @call, status: :created, location: @call }
      else
        format.html { render action: "new" }
        format.json { render json: @call.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /calls/1
  # PUT /calls/1.json
  def update
    @call = Call.find(params[:id])

    respond_to do |format|
      if @call.update_attributes(params[:call])
        format.html { redirect_to @call, notice: 'Call was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @call.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calls/1
  # DELETE /calls/1.json
  def destroy
    @call = Call.find(params[:id])
    @call.destroy

    respond_to do |format|
      format.html { redirect_to calls_url }
      format.json { head :no_content }
    end
  end
end
