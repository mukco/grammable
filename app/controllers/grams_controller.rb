class GramsController < ApplicationController
 before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

 def new
    #creates a new gram object 
    @gram = Gram.new
  end

  def index
    #root page for application 
    @grams = Gram.all 

  end

  def show
    #displays a gram from the database or returns nil 
    @gram = Gram.find_by_id(params[:id])
    return render_not_found if @gram.blank?
  end

  def edit
    #renders form for gram message to be edited 
    @gram = Gram.find_by_id(params[:id])
    return render_not_found if @gram.blank?
    return render_not_found(:forbidden) if @gram.user != current_user  
  end

  def create
    #creates a gram object 
    @gram = current_user.grams.create(gram_params)
    if @gram.valid?
      #while creating if gram passes validations it redirrects back to root path 
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end 
  end

  def update 
    @gram = Gram.find_by_id(params[:id])
    return render_not_found if @gram.blank? 
    return render_not_found(:forbidden) if @gram.user != current_user
    
    @gram.update_attributes(gram_params) 
    if @gram.valid? 
      redirect_to root_path 
    else 
      return render :edit, status: :unprocessable_entity 
    end 
  end 

  def destroy
    @gram = Gram.find_by_id(params[:id])
    return render_not_found if @gram.blank?
    return render_not_found(:forbidden) if @gram.user != current_user
    
    @gram.destroy
    redirect_to root_path
  end

  private

  def gram_params
    #params for gram creation 
    params.require(:gram).permit(:message, :picture)
  end


end