class FoodsController < ApplicationController
  def index
    @foods = Food.all
  end
  
  def new
    @food = Food.new
    @options = Option.all
  end
  
  def create
    @food = Food.new(
      name: params[:name],
      op_id: params[:op_id],
      # image: params[:image]
      )
    if @food.save
      redirect_to action: 'check', id: @food.id
    else
      redirect_to action: "new"
    end
  end
  
  def check
    @food = Food.find_by(id: params[:id])
    @option = Option.find_by(id: @food.op_id)
  end
  
  def save
    @food = Food.find_by(id: params[:id])

    if params[:image]
      @food.image = "#{@food.id}.jpg"
      p_image = params[:image]
      File.binwrite("public/foods/#{@food.op_id}/#{@food.image}", p_image.read)
    end
    @food.save
    
    p '============='
    p @food.image
    p '============='
    
    array = []
    array  = @food.get_positions
    
    if @food.update(x: array[0], y: array[1], width: array[2], height: array[3])
      redirect_to action: 'final', id: @food.id
    else
      redirect_to action: 'check', id: @food.id
    end
  end
  
  def final
    @food = Food.find_by(id: params[:id])
  end
end
