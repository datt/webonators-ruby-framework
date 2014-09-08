require "erubis"
class WebitController

  protected

  def render action
    template = Erubis::Eruby.new File.read("#{@path}/app/views/#{action}.html.erb")
    content = template.result(binding)
    get_layout { content }
  end

  def redirect_to url
    {url: url}
  end

  private

   def get_layout
    template = Erubis::Eruby.new File.read("#{@path}/app/views/layout/application.html.erb")
    template.result(binding)
   end
end
