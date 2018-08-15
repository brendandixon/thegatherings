# == Route Map
#
#                          Prefix Verb   URI Pattern                                                                              Controller#Action
#              new_member_session GET    /member/signin(.:format)                                                                 member/sessions#new
#                  member_session POST   /member/signin(.:format)                                                                 member/sessions#create
#          destroy_member_session DELETE /member/signout(.:format)                                                                member/sessions#destroy
#             new_member_password GET    /member/password/new(.:format)                                                           devise/passwords#new
#            edit_member_password GET    /member/password/edit(.:format)                                                          devise/passwords#edit
#                 member_password PATCH  /member/password(.:format)                                                               devise/passwords#update
#                                 PUT    /member/password(.:format)                                                               devise/passwords#update
#                                 POST   /member/password(.:format)                                                               devise/passwords#create
#      cancel_member_registration GET    /member/cancel(.:format)                                                                 member/registrations#cancel
#         new_member_registration GET    /member/signup(.:format)                                                                 member/registrations#new
#        edit_member_registration GET    /member/edit(.:format)                                                                   member/registrations#edit
#             member_registration PATCH  /member(.:format)                                                                        member/registrations#update
#                                 PUT    /member(.:format)                                                                        member/registrations#update
#                                 DELETE /member(.:format)                                                                        member/registrations#destroy
#                                 POST   /member(.:format)                                                                        member/registrations#create
#               new_member_unlock GET    /member/unlock/new(.:format)                                                             devise/unlocks#new
#                   member_unlock GET    /member/unlock(.:format)                                                                 devise/unlocks#show
#                                 POST   /member/unlock(.:format)                                                                 devise/unlocks#create
#                          signin GET    /signin(.:format)                                                                        member/sessions#new
#                         signout DELETE /signout(.:format)                                                                       member/sessions#destroy
#                          signup GET    /signup(.:format)                                                                        member/registrations#signup
#                            root GET    /                                                                                        welcome#show
#                         welcome GET    /welcome(.:format)                                                                       welcome#show
#                          routes GET    /routes(.:format)                                                                        application#routes
#              campuses_dashboard GET    /dashboard/campuses(.:format)                                                            dashboard#campuses
#            gatherings_dashboard GET    /dashboard/gatherings(.:format)                                                          dashboard#gatherings
#                       dashboard GET    /dashboard(.:format)                                                                     dashboard#show
#              attendance_reports GET    /reports/attendance(.:format)                                                            reports#attendance
#                     gap_reports GET    /reports/gap(.:format)                                                                   reports#gap
#                         reports GET    /reports(.:format)                                                                       reports#show
#              assigned_overseers GET    /assigned_overseers(.:format)                                                            assigned_overseers#index
#                                 POST   /assigned_overseers(.:format)                                                            assigned_overseers#create
#           new_assigned_overseer GET    /assigned_overseers/new(.:format)                                                        assigned_overseers#new
#          edit_assigned_overseer GET    /assigned_overseers/:id/edit(.:format)                                                   assigned_overseers#edit
#               assigned_overseer GET    /assigned_overseers/:id(.:format)                                                        assigned_overseers#show
#                                 PATCH  /assigned_overseers/:id(.:format)                                                        assigned_overseers#update
#                                 PUT    /assigned_overseers/:id(.:format)                                                        assigned_overseers#update
#                                 DELETE /assigned_overseers/:id(.:format)                                                        assigned_overseers#destroy
#              member_preferences GET    /members/:member_id/preferences(.:format)                                                preferences#index
#                         members GET    /members(.:format)                                                                       members#index
#                     edit_member GET    /members/:id/edit(.:format)                                                              members#edit
#                          member GET    /members/:id(.:format)                                                                   members#show
#                                 PATCH  /members/:id(.:format)                                                                   members#update
#                                 PUT    /members/:id(.:format)                                                                   members#update
#                                 DELETE /members/:id(.:format)                                                                   members#destroy
#                     memberships GET    /memberships(.:format)                                                                   memberships#index
#                                 POST   /memberships(.:format)                                                                   memberships#create
#                  new_membership GET    /memberships/new(.:format)                                                               memberships#new
#                 edit_membership GET    /memberships/:id/edit(.:format)                                                          memberships#edit
#                      membership GET    /memberships/:id(.:format)                                                               memberships#show
#                                 PATCH  /memberships/:id(.:format)                                                               memberships#update
#                                 PUT    /memberships/:id(.:format)                                                               memberships#update
#                                 DELETE /memberships/:id(.:format)                                                               memberships#destroy
#              search_preferences GET    /preferences/search(.:format)                                                            preferences#search
#         add_preference_taggings PUT    /preferences/:preference_id/taggings/add(.:format)                                       taggings#add
#                                 PATCH  /preferences/:preference_id/taggings/add(.:format)                                       taggings#add
#      remove_preference_taggings DELETE /preferences/:preference_id/taggings/remove(.:format)                                    taggings#remove
#         set_preference_taggings POST   /preferences/:preference_id/taggings/set(.:format)                                       taggings#set
#             preference_taggings GET    /preferences/:preference_id/taggings(.:format)                                           taggings#index
#                                 POST   /preferences/:preference_id/taggings(.:format)                                           taggings#create
#          new_preference_tagging GET    /preferences/:preference_id/taggings/new(.:format)                                       taggings#new
#                    edit_tagging GET    /taggings/:id/edit(.:format)                                                             taggings#edit
#                         tagging GET    /taggings/:id(.:format)                                                                  taggings#show
#                                 PATCH  /taggings/:id(.:format)                                                                  taggings#update
#                                 PUT    /taggings/:id(.:format)                                                                  taggings#update
#                                 DELETE /taggings/:id(.:format)                                                                  taggings#destroy
#                     preferences GET    /preferences(.:format)                                                                   preferences#index
#                                 POST   /preferences(.:format)                                                                   preferences#create
#                  new_preference GET    /preferences/new(.:format)                                                               preferences#new
#                 edit_preference GET    /preferences/:id/edit(.:format)                                                          preferences#edit
#                      preference GET    /preferences/:id(.:format)                                                               preferences#show
#                                 PATCH  /preferences/:id(.:format)                                                               preferences#update
#                                 PUT    /preferences/:id(.:format)                                                               preferences#update
#                                 DELETE /preferences/:id(.:format)                                                               preferences#destroy
#          request_request_owners GET    /requests/:request_id/request_owners(.:format)                                           request_owners#index
#                                 POST   /requests/:request_id/request_owners(.:format)                                           request_owners#create
#       new_request_request_owner GET    /requests/:request_id/request_owners/new(.:format)                                       request_owners#new
#                        requests GET    /requests(.:format)                                                                      requests#index
#                                 POST   /requests(.:format)                                                                      requests#create
#                     new_request GET    /requests/new(.:format)                                                                  requests#new
#                    edit_request GET    /requests/:id/edit(.:format)                                                             requests#edit
#                         request GET    /requests/:id(.:format)                                                                  requests#show
#                                 PATCH  /requests/:id(.:format)                                                                  requests#update
#                                 PUT    /requests/:id(.:format)                                                                  requests#update
#                                 DELETE /requests/:id(.:format)                                                                  requests#destroy
#                  request_owners GET    /request_owners(.:format)                                                                request_owners#index
#                                 POST   /request_owners(.:format)                                                                request_owners#create
#               new_request_owner GET    /request_owners/new(.:format)                                                            request_owners#new
#              edit_request_owner GET    /request_owners/:id/edit(.:format)                                                       request_owners#edit
#                   request_owner GET    /request_owners/:id(.:format)                                                            request_owners#show
#                                 PATCH  /request_owners/:id(.:format)                                                            request_owners#update
#                                 PUT    /request_owners/:id(.:format)                                                            request_owners#update
#                                 DELETE /request_owners/:id(.:format)                                                            request_owners#destroy
#    gathering_assigned_overseers GET    /gatherings/:gathering_id/assigned_overseers(.:format)                                   assigned_overseers#index
#                                 POST   /gatherings/:gathering_id/assigned_overseers(.:format)                                   assigned_overseers#create
# new_gathering_assigned_overseer GET    /gatherings/:gathering_id/assigned_overseers/new(.:format)                               assigned_overseers#new
#                                 GET    /assigned_overseers/:id/edit(.:format)                                                   assigned_overseers#edit
#                                 GET    /assigned_overseers/:id(.:format)                                                        assigned_overseers#show
#                                 PATCH  /assigned_overseers/:id(.:format)                                                        assigned_overseers#update
#                                 PUT    /assigned_overseers/:id(.:format)                                                        assigned_overseers#update
#                                 DELETE /assigned_overseers/:id(.:format)                                                        assigned_overseers#destroy
#      meeting_attendance_records GET    /meetings/:meeting_id/attendance(.:format)                                               attendance_records#index
#                                 POST   /meetings/:meeting_id/attendance(.:format)                                               attendance_records#create
#   new_meeting_attendance_record GET    /meetings/:meeting_id/attendance/new(.:format)                                           attendance_records#new
#          edit_attendance_record GET    /attendance/:id/edit(.:format)                                                           attendance_records#edit
#               attendance_record GET    /attendance/:id(.:format)                                                                attendance_records#show
#                                 PATCH  /attendance/:id(.:format)                                                                attendance_records#update
#                                 PUT    /attendance/:id(.:format)                                                                attendance_records#update
#                                 DELETE /attendance/:id(.:format)                                                                attendance_records#destroy
#              gathering_meetings GET    /gatherings/:gathering_id/meetings(.:format)                                             meetings#index
#                    edit_meeting GET    /meetings/:id/edit(.:format)                                                             meetings#edit
#                         meeting GET    /meetings/:id(.:format)                                                                  meetings#show
#                                 PATCH  /meetings/:id(.:format)                                                                  meetings#update
#                                 PUT    /meetings/:id(.:format)                                                                  meetings#update
#                                 DELETE /meetings/:id(.:format)                                                                  meetings#destroy
#     attendees_campus_gatherings GET    /campuses/:campus_id/gatherings/attendees(.:format)                                      gatherings#attendees
#           gathering_memberships GET    /gatherings/:gathering_id/memberships(.:format)                                          memberships#index
#                                 POST   /gatherings/:gathering_id/memberships(.:format)                                          memberships#create
#        new_gathering_membership GET    /gatherings/:gathering_id/memberships/new(.:format)                                      memberships#new
#                                 GET    /memberships/:id/edit(.:format)                                                          memberships#edit
#                                 GET    /memberships/:id(.:format)                                                               memberships#show
#                                 PATCH  /memberships/:id(.:format)                                                               memberships#update
#                                 PUT    /memberships/:id(.:format)                                                               memberships#update
#                                 DELETE /memberships/:id(.:format)                                                               memberships#destroy
#               gathering_members GET    /gatherings/:gathering_id/members(.:format)                                              members#index
#              gathering_requests GET    /gatherings/:gathering_id/requests(.:format)                                             requests#index
#        search_campus_gatherings GET    /campuses/:campus_id/gatherings/search(.:format)                                         gatherings#search
#          add_gathering_taggings PUT    /gatherings/:gathering_id/taggings/add(.:format)                                         taggings#add
#                                 PATCH  /gatherings/:gathering_id/taggings/add(.:format)                                         taggings#add
#       remove_gathering_taggings DELETE /gatherings/:gathering_id/taggings/remove(.:format)                                      taggings#remove
#          set_gathering_taggings POST   /gatherings/:gathering_id/taggings/set(.:format)                                         taggings#set
#              gathering_taggings GET    /gatherings/:gathering_id/taggings(.:format)                                             taggings#index
#                                 POST   /gatherings/:gathering_id/taggings(.:format)                                             taggings#create
#           new_gathering_tagging GET    /gatherings/:gathering_id/taggings/new(.:format)                                         taggings#new
#                                 GET    /taggings/:id/edit(.:format)                                                             taggings#edit
#                                 GET    /taggings/:id(.:format)                                                                  taggings#show
#                                 PATCH  /taggings/:id(.:format)                                                                  taggings#update
#                                 PUT    /taggings/:id(.:format)                                                                  taggings#update
#                                 DELETE /taggings/:id(.:format)                                                                  taggings#destroy
#               campus_gatherings GET    /campuses/:campus_id/gatherings(.:format)                                                gatherings#index
#                                 POST   /campuses/:campus_id/gatherings(.:format)                                                gatherings#create
#            new_campus_gathering GET    /campuses/:campus_id/gatherings/new(.:format)                                            gatherings#new
#                  edit_gathering GET    /gatherings/:id/edit(.:format)                                                           gatherings#edit
#                       gathering GET    /gatherings/:id(.:format)                                                                gatherings#show
#                                 PATCH  /gatherings/:id(.:format)                                                                gatherings#update
#                                 PUT    /gatherings/:id(.:format)                                                                gatherings#update
#                                 DELETE /gatherings/:id(.:format)                                                                gatherings#destroy
#                 respond_request POST   /requests/:id/respond(.:format)                                                          requests#respond
#                 campus_requests GET    /campuses/:campus_id/requests(.:format)                                                  requests#index
#                                 POST   /campuses/:campus_id/requests(.:format)                                                  requests#create
#              new_campus_request GET    /campuses/:campus_id/requests/new(.:format)                                              requests#new
#              campus_memberships GET    /campuses/:campus_id/memberships(.:format)                                               memberships#index
#                                 POST   /campuses/:campus_id/memberships(.:format)                                               memberships#create
#           new_campus_membership GET    /campuses/:campus_id/memberships/new(.:format)                                           memberships#new
#                                 GET    /memberships/:id/edit(.:format)                                                          memberships#edit
#                                 GET    /memberships/:id(.:format)                                                               memberships#show
#                                 PATCH  /memberships/:id(.:format)                                                               memberships#update
#                                 PUT    /memberships/:id(.:format)                                                               memberships#update
#                                 DELETE /memberships/:id(.:format)                                                               memberships#destroy
#                  campus_members GET    /campuses/:campus_id/members(.:format)                                                   members#index
#              community_campuses GET    /communities/:community_id/campuses(.:format)                                            campuses#index
#                                 POST   /communities/:community_id/campuses(.:format)                                            campuses#create
#            new_community_campus GET    /communities/:community_id/campuses/new(.:format)                                        campuses#new
#                     edit_campus GET    /campuses/:id/edit(.:format)                                                             campuses#edit
#                          campus GET    /campuses/:id(.:format)                                                                  campuses#show
#                                 PATCH  /campuses/:id(.:format)                                                                  campuses#update
#                                 PUT    /campuses/:id(.:format)                                                                  campuses#update
#                                 DELETE /campuses/:id(.:format)                                                                  campuses#destroy
#                   category_tags GET    /categories/:category_id/tags(.:format)                                                  tags#index
#                                 POST   /categories/:category_id/tags(.:format)                                                  tags#create
#                new_category_tag GET    /categories/:category_id/tags/new(.:format)                                              tags#new
#                        edit_tag GET    /tags/:id/edit(.:format)                                                                 tags#edit
#                             tag GET    /tags/:id(.:format)                                                                      tags#show
#                                 PATCH  /tags/:id(.:format)                                                                      tags#update
#                                 PUT    /tags/:id(.:format)                                                                      tags#update
#                                 DELETE /tags/:id(.:format)                                                                      tags#destroy
#            community_categories GET    /communities/:community_id/categories(.:format)                                          categories#index
#                                 POST   /communities/:community_id/categories(.:format)                                          categories#create
#          new_community_category GET    /communities/:community_id/categories/new(.:format)                                      categories#new
#                   edit_category GET    /categories/:id/edit(.:format)                                                           categories#edit
#                        category GET    /categories/:id(.:format)                                                                categories#show
#                                 PATCH  /categories/:id(.:format)                                                                categories#update
#                                 PUT    /categories/:id(.:format)                                                                categories#update
#                                 DELETE /categories/:id(.:format)                                                                categories#destroy
#  attendees_community_gatherings GET    /communities/:community_id/gatherings/attendees(.:format)                                gatherings#attendees
#     search_community_gatherings GET    /communities/:community_id/gatherings/search(.:format)                                   gatherings#search
#            community_gatherings GET    /communities/:community_id/gatherings(.:format)                                          gatherings#index
#    search_community_preferences GET    /communities/:community_id/preferences/search(.:format)                                  preferences#search
#           community_preferences GET    /communities/:community_id/preferences(.:format)                                         preferences#index
#                                 POST   /communities/:community_id/preferences(.:format)                                         preferences#create
#        new_community_preference GET    /communities/:community_id/preferences/new(.:format)                                     preferences#new
#                                 GET    /preferences/:id/edit(.:format)                                                          preferences#edit
#                                 GET    /preferences/:id(.:format)                                                               preferences#show
#                                 PATCH  /preferences/:id(.:format)                                                               preferences#update
#                                 PUT    /preferences/:id(.:format)                                                               preferences#update
#                                 DELETE /preferences/:id(.:format)                                                               preferences#destroy
#           community_memberships GET    /communities/:community_id/memberships(.:format)                                         memberships#index
#                                 POST   /communities/:community_id/memberships(.:format)                                         memberships#create
#        new_community_membership GET    /communities/:community_id/memberships/new(.:format)                                     memberships#new
#                                 GET    /memberships/:id/edit(.:format)                                                          memberships#edit
#                                 GET    /memberships/:id(.:format)                                                               memberships#show
#                                 PATCH  /memberships/:id(.:format)                                                               memberships#update
#                                 PUT    /memberships/:id(.:format)                                                               memberships#update
#                                 DELETE /memberships/:id(.:format)                                                               memberships#destroy
#               community_members GET    /communities/:community_id/members(.:format)                                             members#index
#              community_requests GET    /communities/:community_id/requests(.:format)                                            requests#index
#                     communities GET    /communities(.:format)                                                                   communities#index
#                                 POST   /communities(.:format)                                                                   communities#create
#                   new_community GET    /communities/new(.:format)                                                               communities#new
#                  edit_community GET    /communities/:id/edit(.:format)                                                          communities#edit
#                       community GET    /communities/:id(.:format)                                                               communities#show
#                                 PATCH  /communities/:id(.:format)                                                               communities#update
#                                 PUT    /communities/:id(.:format)                                                               communities#update
#                                 DELETE /communities/:id(.:format)                                                               communities#destroy
#              rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
#       rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#              rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
#       update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#            rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create

Rails.application.routes.draw do

  concern :attended do
    get 'attendees', on: :collection
  end

  concern :joinable do
    resources :memberships, shallow: true
    resources :members, only: [:index]
  end

  concern :requestable do
    resources :requests, shallow: true, only: [:index]
  end

  concern :searchable do
    get 'search', on: :collection
  end

  concern :taggable do
    resources :taggings, shallow: true do
      collection do
        put 'add', to: 'taggings#add'
        patch 'add', to: 'taggings#add'
        delete 'remove', to: 'taggings#remove'
        post 'set', to: 'taggings#set'
      end
    end
  end

  devise_for :member,
    controllers: {
      registrations: 'member/registrations',
      sessions: 'member/sessions'
    },
    path_names: {
      sign_in: 'signin',
      sign_out: 'signout',
      sign_up: 'signup'
    }
 
  devise_scope :member do
    get 'signin', to: 'member/sessions#new'
    delete 'signout', to: 'member/sessions#destroy'
    get 'signup', to: 'member/registrations#signup'
  end

  root to: 'welcome#show'
  resource :welcome, only: [:show], controller: :welcome

  get 'routes', controller: :application

  resource :dashboard, controller: :dashboard, only: [:show] do
    get 'campuses'
    get 'gatherings'
  end
  
  resource :reports, only: [:show] do
    get 'attendance'
    get 'gap'
  end

  resources :assigned_overseers
  resources :members, only: [:index, :show, :edit, :update, :destroy] do
    resources :preferences, shallow: true, only: [:index]
  end
  resources :memberships
  resources :preferences, concerns: [:searchable, :taggable]
  resources :requests do
    resources :request_owners, shallow: true, only: [:index, :create, :new]
  end
  resources :request_owners

  resources :communities, concerns: [:joinable, :requestable] do

    resources :campuses, shallow: true, concerns: [:joinable] do
      resources :gatherings, shallow: true, concerns: [:attended, :joinable, :requestable, :searchable, :taggable] do
        resources :assigned_overseers, shallow: true
        resources :meetings, shallow: true, except: [:create, :new] do
          resources :attendance_records, path: :attendance
        end
      end
      resources :requests, shallow: true, only: [:index, :create, :new] do
        post 'respond', on: :member
      end
    end

    resources :categories, shallow: true do
      resources :tags
    end
    resources :gatherings, shallow: true, only: [:index], concerns: [:attended, :searchable]
    resources :preferences, shallow: true, concerns: [:searchable]

  end

end
