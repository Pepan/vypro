Vypro::Application.routes.draw do

	devise_for :users

	get "page/home"

	get "page/help"

	resources :events do

		member do
			get :description
		end

		collection do
			get :mark_as_viewed
		end
	end

	resources :projects do

		member do
			get :description
			put :duplicate
		end

		resources :tasks do

			member do
				get :description
				put :approve
			end

			collection do
				get :tree
				get :moreover
				get :younger
			end
			
			resources :efforts do
				member do
					get :description
				end
			end
			
			resources :tasks, :as => 'subtasks', :path => 'subtasks', :only => [:new, :create]
			
			resources :notes
			resources :annexes
		end
		
		resources :project_user_relations, :as => 'user_relations', :path => 'user_relations'
		# pro mapovani path formularem
		resources :project_user_relations, :only => [:index] do
			resources :invoices
		end

		resources :sprints, :except => [:index, :edit, :destroy] do

			member do
				get :description
			end
			collection do
				put :add
			end

		end
		resources :events, :only => [:index] 
	end
	match '/projects/:project_id/task/new/:type' => 'tasks#new', :constraints => { :project_id => /[0-9]*/,  :type => /[\w]*/ }, :via => :get, :as => 'new_project_task_of_type'
	match '/projects/:project_id/task/:task_id/subtask/new/:type' => 'tasks#new', :constraints => { :project_id => /[0-9]*/, :task_id => /[0-9]*/,  :type => /[\w]*/ }, :via => :get, :as => 'new_project_subtask_of_type'

	resources :companies do
		resources :users, :except => [:destroy]
	end
	
	resources :users, :only => [:destroy]
	resources :invoices, :only => [:show, :edit, :update, :destroy]
	match '/projects/:project_id/project_user_relations/:project_user_relation_id/invoice/new/:type' => 'invoices#new', :constraints => { :project_id => /[0-9]*/, :project_user_relation_id => /[0-9]*/,  :type => /[\w]*/ }, :via => :get, :as => 'new_project_user_invoice_of_type'

	resources :time_sheets, only: [:index, :create]


	# You can have the root of your site routed with "root"
	# root :to => 'welcome#index'
	# root :to => "devise/sessions#new"
	root :to => "page#home"

	# See how all your routes lay out with "rake routes"

	# This is a legacy wild controller route that's not recommended for RESTful applications.
	# Note: This route will make all actions in every controller accessible via GET requests.
	# match ':controller(/:action(/:id(.:format)))'
end
