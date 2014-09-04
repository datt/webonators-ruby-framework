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




   # def render action
   #   if self.class.instance_methods.include? :"#{action}"
   #     action_file = File.expand_path("../../views/#{action}.html.erb", __FILE__)
   #     puts action_file
   #     template = Erubis::Eruby.new File.read(action_file)
   #     template.result(binding)
   #   else
   #       template = "<h1>Error 404. Page not found</h1>
   #       <h2>Some error occurred due to routes.rb.
   #     Please check routes file.</h2>"
   #   end
   # end

end