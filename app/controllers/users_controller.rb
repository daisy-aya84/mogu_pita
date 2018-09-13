class UsersController < ApplicationController
  def index
    @users = User.all
  end

  
  def new
    @user = User.new
  end
  
  def create
    if params[:name] == ""
      flash[:notice] = "名前を入力してください"
      redirect_to("/users/#{params[:id]}/new")
    else
      @user = User.new(
          name: params[:name]
          )
      @user.save
      redirect_to("/users/#{@user.id}/choose")
    end
  end
  
  def choose
    @options = Option.all
    @foods = Food.all
    @user = User.find_by(id: params[:id])
  end

  def eat
    @user = User.find_by(id: params[:id])

    if params[:op_id] == nil
      flash[:notice] = "ひとつ選択して下さい"
      redirect_to("/users/#{@user.id}/choose")
    else
      food_id = params[:op_id]
      @user.op_id = food_id.to_i
      @user.save
      redirect_to("/users/#{@user.id}/edit")
    end
    
  end
  
  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])

    if !params[:image]
      flash[:notice] = "画像を選択してください"
      redirect_to "/users/#{@user.id}/edit"
    else
      @user.image = "#{@user.id}.jpg"
      image = params[:image]
      File.binwrite("public/images/#{@user.image}", image.read)
      @user.save
      member_number = @user.triming
      @user.update(cut_img: "#{member_number}")
      redirect_to("/users/#{@user.id}/set")
    end
  end
  
  def set
    @user = User.find_by(id: params[:id])
  end
  
  def input
    @user = User.find_by(id: params[:id])
    if params[:cut_img] != nil
      @user.update(cut_img: params[:cut_img])
      @foods = Food.where(op_id: @user.op_id)
      f_count = @foods.count
      id_array = [f_count]
      i = 0
      
      @foods.each do |food|
        id_array[i] = food.id
        i += 1
      end
      
      food_count = rand(1..f_count)
      selected_user_id = id_array[food_count - 1]
      @user.update(f_id: selected_user_id)
      r_image = @user.resize(selected_user_id)
      
      @user.update(resized_img: r_image)
      final_image_name = @user.mix(selected_user_id)
      @user.update(final_img: final_image_name)
      
      redirect_to("/users/#{@user.id}/share")
    else
      flash[:notice] = "ひとつ選択して下さい"
      redirect_to "/users/#{@user.id}/set"
    end
  end
  
  def share
    @user = User.find_by(id: params[:id])
    @food = Food.find_by(id: @user.f_id)
  end
end
