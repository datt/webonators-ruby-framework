class PostsController < WebitController

  def initialize
    @path = ROOT
  end

  def index
    @posts =Post.all
    render 'index'
  end

  def new
    @posts =Post.all
    render 'new'
  end

  def show id
    @post= Post.show id
    @comment= Comment.find_by({"posts_id"=>id}).reverse!
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

  def create_comment id, params
    @param = params
    @id = id
    @param["posts_id"] = @id
    Comment.save @param
    redirect_to "/post/#{@id}"
  end

  def edit id
    @id = id
    @post = Post.show @id
    render 'edit'
  end

  def update id, params
    @param = params
    @id = id
    @param["id"] = @id
    Post.update @param
    redirect_to "/post/#{@id}"
  end

  def search_comment params
    @param = params
    puts @param
    @posts = []
    Post.all.each do |post|
      if post["title"].downcase.include? @param["title"].downcase
        @posts.push(post)
      end
    end
    if @posts.length.equal? 0
      @error = "No matching results found. Try Again"
    end
    render 'index'
  end
end