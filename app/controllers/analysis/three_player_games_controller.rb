class Analysis::ThreePlayerGamesController < Analysis::AnalysisController
  def index
    @three_player_games = ThreePlayerGame.paginate :per_page => 15, :page => (params[:page] || 1)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @three_player_games }
      format.json  { render :json => @three_player_games }
    end
  end

  def show
    @three_player_game = ThreePlayerGame.find(params[:id])
    
    strategies = Strategy.all - @three_player_game.strategies
    @strategy_options = strategies.collect {|s| [s.name, s.id]}
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :layout=>false }
      format.json  { render :json => @three_player_game }
    end
  end

  def new
    @three_player_game = ThreePlayerGame.new
    @server_options = Server.all.collect {|s| [s.name, s.id]}
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @three_player_game }
      format.json  { render :json => @three_player_game }
    end
  end

  def edit
    @three_player_game = ThreePlayerGame.find(params[:id])
  end

  def create
    @three_player_game = ThreePlayerGame.new(params[:three_player_game])

    respond_to do |format|
      if @three_player_game.save
        flash[:notice] = 'Game was successfully created.'
        format.html { redirect_to([:analysis, @three_player_game]) }
        format.xml  { render :xml => @three_player_game, :status => :created, :location => [:analysis, @three_player_game] }
        format.json  { render :json => @three_player_game }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @three_player_game.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @three_player_game = ThreePlayerGame.find(params[:id])

    respond_to do |format|
      if @three_player_game.update_attributes(params[:three_player_game])
        flash[:notice] = 'Game was successfully updated.'
        format.html { redirect_to([:analysis, @three_player_game]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @three_player_game.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @three_player_game = ThreePlayerGame.find(params[:id])
    @three_player_game.destroy

    respond_to do |format|
      format.html { redirect_to(analysis_three_player_games_url) }
      format.xml  { head :ok }
    end
  end
end
