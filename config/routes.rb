LinuxfrOrg::Application.routes.draw do
  root :to => 'home#index'

  # News
  resources :sections
  resources :news
  match '/redirect/:id' => 'links#show'

  # Diaries & Users
  resources :users do
    resources :diaries # TODO :as => 'journaux'
  end
  match '/journaux' => 'diaries#index', :as => :diaries, :via => 'get'
  match '/journaux.:format' => 'diaries#index', :as => :diaries, :via => 'get'
  match '/journaux/nouveau' => 'diaries#new', :as => :new_diary, :via => 'get'
  match '/journaux' => 'diaries#create', :as => :post_diary, :via => 'post'

  # Forums
  resources :forums
  match '/posts/nouveau' => 'posts#new', :as => :new_post, :via => 'get'
  match '/posts' => 'posts#create', :as => :post_posts, :via => 'post'

  # Other contents
  resources :interviews do # TODO :as => 'entretiens'
    get :comments, :on => :collection
  end
  resources :polls do # TODO :as => 'sondages'
    post :vote, :on => :member
  end
  resources :trackers do # TODO :as => 'suivi'
    get :comments, :on => :collection
  end
  match '/wiki/changes' => 'wiki_pages#changes', :as => :wiki_changes
  resources :wiki_pages do # TODO :as => 'wiki'
    match '/revisions/:revision' => 'wiki_pages#revision', :as => :revision
  end

  # Nodes
  match '/tableau-de-bord' => 'dashboard#index', :as => :dashboard
  resources :nodes do
    resources :comments
    match '/nodes/:node_id/tags/new' => 'tags#new', :as => :node_new_tag, :via => 'get'
    match '/nodes/:node_id/tags' => 'tags#create', :as => :node_tags, :via => 'post'
  end
  match '/tags' => 'tags#index', :as => :tags, :via => 'get'
  match '/tags/autocomplete' => 'tags#autocomplete_for_tag_name', :as => :complete_tags, :via => 'get'
  match '/tags/:id' => 'tags#show', :as => :tag, :via => 'get'
  match '/tags/:id/public' => 'tags#public', :as => :public_tag, :via => 'get'
  match '/nodes/:node_id/comments/:parent_id/answer' => 'comments#new', :as => :answer_comment
  match '/vote/:action/:node_id' => 'votes#index', :as => :vote
  match '/relevance/:action/:comment_id' => 'relevances#index', :as => :relevance

  # Boards
  match '/board/add' => 'boards#add', :as => :add_board, :via => 'post'
  match '/board' => 'boards#show', :as => :free_board
  match '/board/index.xml' => 'boards#show', :as => :free_board_xml, :format => 'xml'

  # Accounts
  resource :account # TODO :as => 'compte'
  match '/inscription' => 'accounts#new', :as => :signup
  match '/activation/:token' => 'accounts#activate', :as => :activate, :token => ''
  match '/mot-de-passe' => 'accounts#forgot_password', :as => :forgot_password, :via => 'get'
  match '/mot-de-passe' => 'accounts#send_password', :as => :send_password, :via => 'post'
  match '/reset/:token' => 'accounts#reset_password', :as => :reset_password, :token => ''
  match '/desinscription' => 'accounts#delete', :as => :close_account

  # Sessions
  resource :account_session # TODO :as => 'sessions'
  match '/login' => 'account_sessions#new', :as => :login
  match '/logout' => 'account_sessions#destroy', :as => :logout

  # Search
  match '/recherche' => 'search#index', :as => :search
  match '/recherche/:type' => 'search#type', :as => :search_by_type
  match '/recherche/:type/:facet' => 'search#facet', :as => :search_by_facet

  # Redaction
  match '/redaction' => 'redaction#index'
  namespace :redaction do
    resources :news do
      post :submit, :on => :member
    end
    resources :paragraphs
    resources :links
    match '/news/:news_id/links/nouveau' => 'links#new', :as => :news_new_link
  end

  # Moderation
  match '/moderation' => 'moderation#index'
  namespace :moderation do
    resources :news do
      match '/show_diff/:sha' => 'news#show_diff', :as => :show_diff
    end
    resources :interviews do # TODO :as => 'entretiens'
      member do
        post :contact
        post :publish
        post :refuse
        post :accept
      end
    end
    resources :polls do # TODO :as => 'sondages'
      member do
        post :refuse
        post :accept
      end
    end
  end

  # Admin
  match '/admin' => 'admin#index'
  namespace :admin do
    resources :accounts # TODO :as => 'comptes'
    resources :responses # TODO :as => 'reponses'
    resources :sections
    resources :forums
    resources :categories
    resources :banners # TODO :as => 'bannieres'
    resource :logo
    resources :friend_sites do # TODO :as => 'sites_amis'
      member do
        post :lower
        post :higher
      end
    end
    resources :pages
  end

  # Static pages
  match '/proposer_un_contenu' => 'static#proposer_un_contenu', :as => :submit_content
  match '/proposer_un_contenu_quand_on_est_anonyme' => 'static#proposer_un_contenu_quand_on_est_anonyme', :as => :submit_anonymous
  match '/changelog' => 'static#changelog', :as => :changelog
  match ':id' => 'static#show', :as => :static
end
