class DagboekController < ApplicationController
  def index
    @dag = params[:datum].to_date if params.has_key? 'datum'
    @dag = DateTime.now.to_date if @dag.nil?
    
    @queue = Dagboek.voor(@dag)
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
    @dagboek = Dagboek.find(params[:id])
    
    status = params.delete(:status)
    params.delete(:action)
    params.delete(:controller)
    
    
    
    if status == 'Gedaan'
      insuline_ref = params.delete(:item)
      insuline_id = insuline_ref.insuline_id
      params[:insuline_id] = 
    
      @dagboek.update_attributes(params)
      @dagboek.uitgevoerd!
    elsif status == 'Overslaan'
      @dagboek.overgeslagen!
    else
      @dagboek.wacht!
    end
    
    
    redirect_to '/', :status => :found
  end
end
