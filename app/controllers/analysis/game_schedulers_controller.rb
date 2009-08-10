class Analysis::GameSchedulersController < Analysis::AnalysisController
  
  def index
    @game_schedulers = GameScheduler.paginate :per_page => 15, :page => (params[:page] || 1)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @game_schedulers }
      format.json  { render :json => @game_schedulers }
    end
  end

  def show
    @game_scheduler = GameScheduler.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game_scheduler }
      format.json  { render :json => @game_scheduler }
    end
  end

  def new
    @game_scheduler = GameScheduler.new
    @game_options = Game.all.collect {|s| [s.name, s.id]}
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game_scheduler }
      format.json  { render :json => @game_scheduler }
    end
  end

  def edit
    @game_scheduler = GameScheduler.find(params[:id])
  end

  def create
    @game_scheduler = GameScheduler.new(params[:game_scheduler])

    respond_to do |format|
      if @game_scheduler.save
        flash[:notice] = 'Game scheduler was successfully created.'
        format.html { redirect_to([:analysis, @game_scheduler]) }
        format.xml  { render :xml => @game_scheduler, :status => :created, :location => [:analysis, @game_scheduler] }
        format.json  { render :json => @game_scheduler }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game_scheduler.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @game_scheduler = GameScheduler.find(params[:id])

    respond_to do |format|
      if @game_scheduler.update_attributes(params[:game_scheduler])
        flash[:notice] = 'Game scheduler was successfully updated.'
        format.html { redirect_to([:analysis, @game_scheduler]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game_scheduler.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @game_scheduler = GameScheduler.find(params[:id])
    @game_scheduler.destroy

    respond_to do |format|
      format.html { redirect_to(analysis_game_schedulers_url) }
      format.xml  { head :ok }
    end
  end
end
