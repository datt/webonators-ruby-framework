class PostsController < WebitController

  def initialize
    @path = File.expand_path("../../.", __FILE__)
  end
  def index
    @posts =Post.all
    render 'index', @path
  end

  def new
    render 'new',@path
  end

  def show id
    @post= Post.show id
    render 'show',@path
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