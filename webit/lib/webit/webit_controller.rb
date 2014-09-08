require "erubis"
class WebitController

  # define -> render() method accepts an action when called from Controller's action
  # and compiles the ERB to HTML of the same name. Returns complete HTML page including layout.
  def render action
    template = Erubis::Eruby.new File.read("#{ROOT}/app/views/#{action}.html.erb")
    content = template.result(binding)
    {html: get_layout { content }, status: 200}
  end

  # define -> redirect_to() method accepts a path from Controller's action
  # and sends the url to response method.
  def redirect_to url
    {url: url, status: 302}
  end

  private

  # define -> get_layout(). Returns the whole HTML file along with layout and body content.
  def get_layout
    template = Erubis::Eruby.new File.read("#{ROOT}/app/views/layout/application.html.erb")
    template.result(binding)
  end
end
