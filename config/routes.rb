Rails.application.routes.draw do

  concern :joinable do
    resources :memberships, shallow: true
  end

  concern :attendance_reportable do
    get 'attendance', to: 'reports#attendance'
  end

  concern :gap_reportable do
    get 'gap', to: 'reports#gap'
  end

  concern :taggable do
    resource :tags, only: [:edit, :update]
  end

  root 'welcome#index'
  get 'welcome', to: 'welcome#index', as: :welcome
 
  devise_scope :member do
    get 'sign_up', to: 'member/registrations#new'
    get 'sign_in', to: 'devise/sessions#new'
    delete 'sign_out', to: 'devise/sessions#destroy'
    get 'member', to: 'member/registrations#show', as: :show_member_registration
  end
  devise_for :member, controllers: {
    registrations: 'member/registrations'
  }
  get 'mygatherings', to: 'members#mygatherings', as: :member_root

  resources :communities do
    resources :campuses, shallow: true, concerns: :joinable do
      resource :reports, concerns: [:attendance_reportable, :gap_reportable], only: :show
    end
    resources :gatherings, shallow: true, concerns: [:joinable, :taggable] do
      get 'search', on: :collection
      get 'gather', on: :member
      resources :attendance_records, path: :attendance
      resources :membership_requests, path: :requests do
        member do
          post "accept", action: "accept"
          post "answer", action: "answer"
          post "dismiss", action: "dismiss"
        end
      end
      resource :reports, concerns: [:attendance_reportable], only: :show
    end
    resources :members
    resources :memberships, shallow: true, concerns: :taggable
    resource :reports, concerns: [:attendance_reportable, :gap_reportable], only: :show
  end

end
