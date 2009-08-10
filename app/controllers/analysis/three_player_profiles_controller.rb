class Analysis::ThreePlayerProfilesController < Analysis::AnalysisController
  def index
    @three_player_profiles = ThreePlayerProfile.paginate :per_page => 15, :page => (params[:page] || 1)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @three_player_profiles }
    end
  end
  
  def show
    @three_player_profile = ThreePlayerProfile.find(params[:id])
    
    @account_options = Account.all.collect {|s| [s.username, s.id]}
    @simulation = @three_player_profile.simulations.build :profile_id=>params[:id]
    
    @total_samples = @three_player_profile.samples.count
    @clean_samples = @three_player_profile.samples.clean.count
    
    @queued_simulations = @three_player_profile.simulations.queued.count
    @running_simulations = @three_player_profile.simulations.running.count
    @complete_simulations = @three_player_profile.simulations.complete.count
    @failed_simulations = @three_player_profile.simulations.failed.count
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @three_player_profile }
      format.json  { render :json => @three_player_profile }
    end
  end

  def new
    @three_player_profile = ThreePlayerProfile.new
    @server_options = Server.all.collect {|s| [s.name, s.id]}
    @strategy_options = Strategy.all.collect {|s| [s.name, s.id]}
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @three_player_profile }
      format.json  { render :json => @three_player_profile }  
    end
  end

  def create
    @three_player_profile = ThreePlayerProfile.new(params[:three_player_profile])

    
    respond_to do |format|
      if @three_player_profile.save
        flash[:notice] = 'Profile was successfully created.'
        format.html { redirect_to([:analysis, @three_player_profile]) }
        format.xml  { render :xml => @three_player_profile, :status => :created, :location => [:analysis, @three_player_profile] }
      else
        format.html { 
          @server_options = Server.all.collect {|s| [s.name, s.id]}
          @strategy_options = Strategy.all.collect {|s| [s.name, s.id]}
          render :action => "new"
        }
        format.xml  { render :xml => @three_player_profile.errors, :status => :unprocessable_entity }
      end
    end
  end
end
