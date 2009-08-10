class Analysis::StrategiesController < Analysis::AnalysisController
    
  def index
    @strategies = Strategy.paginate :per_page => 15, :page => (params[:page] || 1)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @strategies }
      format.json  { render :json => @strategies }
    end
  end

  def show
    @strategy = Strategy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @strategy }
      format.json  { render :json => @strategy }
    end
  end

  def new
    @strategy = Strategy.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @strategy }
    end
  end

  def edit
    @strategy = Strategy.find(params[:id])
  end

  def create
    @strategy = Strategy.new(params[:strategy])

    respond_to do |format|
      if @strategy.save
        flash[:notice] = 'Strategy was successfully created.'
        format.html { redirect_to([:analysis, @strategy]) }
        format.xml  { render :xml => @strategy, :status => :created, :location => [:analysis, @strategy] }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @strategy.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @strategy = Strategy.find(params[:id])

    respond_to do |format|
      if @strategy.update_attributes(params[:strategy])
        flash[:notice] = 'Strategy was successfully updated.'
        format.html { redirect_to([:analysis, @strategy]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @strategy.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @strategy = Strategy.find(params[:id])
    @strategy.destroy

    respond_to do |format|
      format.html { redirect_to(analysis_strategies_url) }
      format.xml  { head :ok }
    end
  end
end
