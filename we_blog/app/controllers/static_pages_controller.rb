class StaticPagesController < WebitController

  def initialize
    @path = File.expand_path("../../.", __FILE__)
  end

  def home
    render 'home', @path
  end

  def about
    render 'about', @path
  end

  def contact
    render 'contact', @path
  end

end