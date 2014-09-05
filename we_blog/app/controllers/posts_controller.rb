class PostsController < WebitController
  
  def initialize
    @path = ROOT
  end
  
  def index
    @posts =Post.all
    render 'index'
  end

  def new
    render 'new'
  end

  def show id
    @post= Post.show id
    render 'show'
  end

  def create params
    @param = params
    Post.save @param
    redirect_to '/posts'
  end

  def destroy id
    Post.destroy id
    redirect_to '/posts'
  end

end
