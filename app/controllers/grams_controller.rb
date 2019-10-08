class GramsController < ApplicationController
   # require the user signed-in before controller 
   before_action :authenticate_user!, only: [:new, :create]
  # root page for the application 
  def index 
  end 

  def show 
    #searches for the gram using id 
    #returns nil if the object is not in database 
    @gram = Gram.find_by_id(params[:id])
    if @gram.blank? 
      render plain: 'Not found :(', status: :not_found 
    end 

  end 
  # saves a Gram to the database and redirects back to index 
  def create 
    @gram = current_user.grams.create(gram_params)
    # validates the gram to make sure it is passing validation 
    if @gram.valid? 
      redirect_to root_path
    else 
      # returns page Unauthorized because of http status" 
      @gram.errors.messages
      render plain: "#{@gram.errors.messages}", status: :unprocessable_entity
    end 
  end 
  #creates a new Gram object 
  def new 
    @gram = Gram.new
  end 


  private 

  def gram_params 
    params.require(:gram).permit(:message)
  end 

end
