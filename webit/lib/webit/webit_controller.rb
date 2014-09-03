require "erubis"
class WebitController

  def index
    model_name = get_model_name
    model_name.all
  end

  def show id
    model_name = get_model_name
    model_name.show id
  end

  def new
    model_name = get_model_name
    @obj = model_name.new
  end

  def create
    model_name = get_model_name
    @obj = model_name.new
    @obj.save
  end

  def edit

  end

  def update
    model_name = get_model_name
    model_name.update id
  end

  def destroy id
    model_name = get_model_name
    model_name.destroy id
  end

  def render action
    if self.class.instance_methods.include? :"#{action}"
      template = Erubis::Eruby.new File.read("../views/#{action}.html.erb")
      template.result(binding)
    else
      template = "<h1>Error 404. Page not found</h1>
      <h2>Some error occurred due to routes.rb.
      Please check routes file.</h2>"
    end
  end

  def redirect_to url
    {url: url}
  end

  def get_model_name
    class_name = self.class.name
    splitted = class_name.split /(?=[A-Z])/
    splitted.delete_at -1
    model_name_plural = splitted.join('')
    model_name = model_name_plural[0...-1]
    model_name = Object.const_get "#{model_name}"
  end
end
