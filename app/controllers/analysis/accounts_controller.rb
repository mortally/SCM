class Analysis::AccountsController < Analysis::AnalysisController
  def index
    @accounts = Account.all

    respond_to do |format|
      format.xml  { render :xml => @accounts }
    end
  end
  
  def show
    @account = Account.find(params[:id])

    respond_to do |format|
      format.xml  { render :xml => @account }
      format.json  { render :json => @account }
    end
  end
end
