class StaticPagesController < WebitController

  def initialize
    @path = ROOT
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