class Analysis::ServersController < Analysis::AnalysisController
  
  
  def index
    @servers = Server.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @servers }
      format.json  { render :json => @servers }
    end
  end

  def show
    @server = Server.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @server }
      format.json  { render :json => @server }
    end
  end

  def new
    @server = Server.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @server }
      format.json  { render :json => @server }
    end
  end

  def edit
    @server = Server.find(params[:id])
  end

  def create
    @server = Server.new(params[:server])

    respond_to do |format|
      if @server.save
        flash[:notice] = 'Server was successfully created.'
        format.html { redirect_to([:analysis, @server]) }
        format.xml  { render :xml => @server, :status => :created, :location => [:analysis, @server] }
        format.json  { render :json => @server }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @server.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @server = Server.find(params[:id])

    respond_to do |format|
      if @server.update_attributes(params[:server])
        flash[:notice] = 'Server was successfully updated.'
        format.html { redirect_to([:analysis, @server]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @server.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @server = Server.find(params[:id])
    @server.destroy

    respond_to do |format|
      format.html { redirect_to(analysis_servers_url) }
      format.xml  { head :ok }
    end
  end
end