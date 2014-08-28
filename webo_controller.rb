class WeboController

  def get_model_name
    class_name = self.class.inspect
    splitted = class_name.split /(?=[A-Z])/
    splitted.delete_at -1
    model_name_plural = splitted.join('')
    model_name = model_name_plural[0...-1]
  end

  def index
    model_name = get_model_name
    eval("#{model_name}.all")
  end

  def show :id
    model_name = get_model_name
    eval("#{model_name}.find :id")
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
    eval("#{model_name}.update :id")
  end

  def destroy
    model_name = get_model_name
    eval("#{model_name}.destroy :id")
  end

end