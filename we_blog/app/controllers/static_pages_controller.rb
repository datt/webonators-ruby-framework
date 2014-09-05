class StaticPagesController < WebitController

  def initialize
    @path = File.expand_path("../../.", __FILE__)
  end

  def home
    render 'home'
  end

  def about
    render 'about'
  end

  def contact
    render 'contact'
  end

end