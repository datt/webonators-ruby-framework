require "erubis"
class WebitController

  # define -> render() method accepts an action when called from Controller's action
  # and compiles the ERB to HTML of the same name. Returns complete HTML page including layout.
  def render action
    template = Erubis::Eruby.new File.read("#{@path}/app/views/#{action}.html.erb")
    content = template.result(binding)
    get_layout { content }
  end

  # define -> redirect_to() method accepts a path from Controller's action
  # and sends the url to response method. 
  def redirect_to url
    {url: url}
  end

  private

  # define -> get_layout. Returns the whole HTML file along with layout and body content.
   def get_layout
    template = Erubis::Eruby.new File.read("#{@path}/app/views/layout/application.html.erb")
    template.result(binding)
   end
end
