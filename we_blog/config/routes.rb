class Routes < WebitRoutes

  get '/posts' do
    goto 'PostsController', 'index'
  end

  get '/post/new' do
    goto 'PostsController', 'new'
  end

  get '/post/:id' do
    goto 'PostsController', 'show'
  end

  get '/post/create' do
    goto 'PostsController', 'create'
  end

  get '/post/:id/destroy' do
    goto 'PostsController', 'destroy'
  end

  get '/' do
    goto 'StaticPagesController', 'home'
  end

  get '/about' do
    goto 'StaticPagesController', 'about'
  end

  get '/contact' do
    goto 'StaticPagesController', 'contact'
  end
end