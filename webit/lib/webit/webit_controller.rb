require "erubis"
class WebitController

  def render action
    if self.class.instance_methods.include? :"#{action}"
      template = Erubis::Eruby.new File.read("#{@path}/views/#{action}.html.erb")
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

end