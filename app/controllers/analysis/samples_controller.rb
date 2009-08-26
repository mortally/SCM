class Analysis::SamplesController < Analysis::AnalysisController
  before_filter :get_simulation
  protect_from_forgery :except => [:create,:update]
  
  def index
    @samples = @simulation.samples.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @samples }
      format.json  { render :json => @samples }
    end
  end

  def show
    @sample = Sample.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sample }
      format.json  { render :json => @sample }
    end
  end
  
  def process_scores
    #TODO-FIX
    @sample = Sample.find(params[:id])
    
    MiddleMan.worker(:maintenance_worker).async_process_sample(:arg => params[:id])
    
    redirect_to([:analysis, @simulation, @sample])
  end
  
  def new
    @sample = @simulation.samples.build :profile_id=>@simulation.profile_id
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sample }
      format.json  { render :json => @sample }
    end
  end

  def edit
    @sample = @simulation.samples.find(params[:id])
  end

  def create  
    @sample = @simulation.samples.build(params[:sample])
    @sample.profile_id = @simulation.profile_id
    
    respond_to do |format|
      if @sample.save
        flash[:notice] = 'Sample was successfully created.'
        format.html { redirect_to([:analysis, @simulation, @sample]) }
        format.xml  { render :xml => @sample, :status => :created, :location => [:analysis, @simulation, @sample] }
        format.json  { render :json => @sample }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sample.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @sample = Sample.find(params[:id])

    respond_to do |format|
      if @sample.update_attributes(params[:sample])
        flash[:notice] = 'Sample was successfully updated.'
        format.html { redirect_to([:analysis, @simulation, @sample]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sample.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @sample = Sample.find(params[:id])
    @sample.destroy

    respond_to do |format|
      format.html { redirect_to(analysis_simulation_samples_url(@simulation)) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def get_simulation
    @simulation = Simulation.find params[:simulation_id]
  end
end
