class WeboController

  def index
    model_name = get_model_name
    eval("#{model_name}").send all
  end

  def show id
    model_name = get_model_name
    eval("#{model_name}").send find id
  end

  def new
    model_name = get_model_name
    @obj = eval("#{model_name}.new")
  end

  def create args
    model_name = get_model_name
    @obj = eval("#{model_name}.new")
    @obj.save args
  end

  def edit

  end

  def update
    model_name = get_model_name
    eval("#{model_name}").send update id
  end

  def destroy
    model_name = get_model_name
    eval("#{model_name}").send destroy id
  end

  def render action
    unless self.class.instance_methods.include? action
      object = self.class.new
      object.send action
      template = Erubis::Eruby.new File.read("tmp/controller/#{action}.html.erb")
      template.result(object.instance_eval {binding})
    else
      template = "<h1>Error 404. Page not found<h1><h2>Some error occurred due to routes.rb. Please check routes file.<h2>"
    end
  end

  private

    def get_model_name
      class_name = self.class.inspect
      splitted = class_name.split /(?=[A-Z])/
      splitted.delete_at -1
      model_name_plural = splitted.join('')
      model_name = model_name_plural[0...-1]
    end

end
