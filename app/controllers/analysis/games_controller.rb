class Analysis::GamesController < Analysis::AnalysisController
  def index
    @games = Game.paginate :per_page => 15, :page => (params[:page] || 1)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games }
    end
  end
end
