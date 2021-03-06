class LinhasController < ApplicationController
=begin
  def get_linhas_evento
    @linhas = Linha.find( :all, :conditions => [" evento_id = ?", params[:id]]  ).sort_by{ |k| 
    k['nome'] }
    #@subsection = SubSection.find_all_by_section_id( params[:id]).sort_by{ |k| k['name'] }
    respond_to do |format|
      format.json  { render :json => @linhas }      
    end
  end
=end
  def get_linhas_by_evento
    @linhas = Linha.where("evento_id = ?", params[:evento_id]).order(nome: :asc)
    respond_to do |format|
      format.json { render :json => @linhas }
    end
  end 
  def get_linhas_minicursos
    @evento = Evento.find_by_nome('XIV CONGIC');
    @linhas = Linha.where("evento_id = ?", @evento)
    respond_to do |format|
      format.json { render :json => @linhas }
    end
  end 
=begin
  def linhas_search
    if params[:evento].present? && params[:evento].strip != ""
      @linhas = Linha.where("evento_id = ?", params[:evento])
    else
      @linhas = Linha.all
    end
  end
=end
end