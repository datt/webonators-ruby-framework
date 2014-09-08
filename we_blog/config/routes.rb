class Routes < WebitRoutes

  get '/' do
    goto 'StaticPagesController', 'home'
  end

  get '/about' do
    goto 'StaticPagesController', 'about'
  end

  get '/contact' do
    goto 'StaticPagesController', 'contact'
  end

  get '/posts' do
    goto 'PostsController', 'index'
  end

  get '/post/new' do
    goto 'PostsController', 'new'
  end

  get '/post/:id' do
    goto 'PostsController', 'show'
  end

  post '/post/create' do
    goto 'PostsController', 'create'
  end

  post '/post/:id/create_comment' do
    goto 'PostsController','create_comment'
  end

  post '/post/result' do
    goto 'PostsController','search_comment'
  end

  get '/post/:id/destroy' do
    goto 'PostsController', 'destroy'
  end

  get '/post/:id/edit' do
   goto 'PostsController', 'edit'
  end

  post '/post/:id/update' do
   goto 'PostsController', 'update'
  end

end