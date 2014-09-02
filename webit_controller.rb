require 'rack'
require 'rack/respond_to'
require_relative 'webit_view'
class WebitController < WebitView

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

  include Rack::RespondTo #mixes in #respond_to

  def self.call(env)
    request = Rack::Request.new(env)
    path = request.path_info
    params = request.params
    # Pass in the env, and RespondTo will retrieve the requested media types
    #response = Rack::Response.new
    # Alternatively, to use standalone you can also assign the media types
     # directly (this will take precedence over the env)
    Rack::RespondTo.media_types = ['text/html']
    body = respond_to do |format|
      unless request.post?
        format.html { render path }
      else
        format.html { render path, params}
      end
      #format.xml  { '<body>xml</body>' }
    end
    [200, {'Content-Type' => Rack::RespondTo.selected_media_type}, [body]]
  end

  #def redirect_to action
  #  res = Rack::Response.new
  #  res.redirect("localhost:3000/post/show")
  #  res.finish
  #end

  def render action
    route_variables = self.class.parse_routes action
    if self.class.instance_methods.include? :"#{action}"
      object = self.class.new
      object.send action
      template = Erubis::Eruby.new File.read("#{action}.html.erb")
      template.result(object.instance_eval {binding})
    else
      template = "<h1>Error 404. Page not found</h1>
      <h2>Some error occurred due to routes.rb.
      Please check routes file.</h2>"
    end
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
