class OptionsController < ApplicationController
  def index
    @options = Option.all
  end

  def new
    @option = Option.new
  end

  def create
    @option = Option.new(
      name: params[:name]
      )
    if @option.save
      flash[:notice] = "「#{@option.name}」登録完了"
      redirect_to action: 'index'
    else
      redirect_to action: "new"
    end
  end
end