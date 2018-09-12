class OptionsController < ApplicationController
  def index
    @options = Option.all
  end
  
  def show
    @option = Option.find_by(id: params[:id])
    p @option
  end
end