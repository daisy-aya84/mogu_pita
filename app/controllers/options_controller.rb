class OptionsController < ApplicationController
  def index
    @options = Option.all
    @foods = Food.all
  end

  def new
    @option = Option.new
  end

  def create
    @option = Option.new(
      name: params[:name]
      )
    if @option.save
      path = "public/foods/#{@option.id}"
      FileUtils.mkdir_p(path) unless FileTest.exist?(path)
      flash[:notice] = "「#{@option.name}」登録完了"
      redirect_to action: 'index'
    else
      redirect_to action: "new"
    end
  end

  def destroy
    @option = Option.find_by(id: params[:id])
    @foods = Food.where(op_id: params[:id])
    if @foods.count > 0
      @foods.each do |food|
        food.destroy
      end
    end
    @option.dir_delete
    @option.destroy
    flash[:notice] = "削除が完了しました"
    redirect_to action: 'index'
  end
end