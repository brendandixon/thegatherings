# == Route Map
#
#                        Prefix Verb   URI Pattern                                                                              Controller#Action
#                          root GET    /                                                                                        member/sessions#new
#                       welcome GET    /welcome(.:format)                                                                       member/sessions#new
#                        signup GET    /signup(.:format)                                                                        member/registrations#signup
#                        signin GET    /signin(.:format)                                                                        member/sessions#new
#                       signout DELETE /signout(.:format)                                                                       member/sessions#destroy
#            new_member_session GET    /member/sign_in(.:format)                                                                member/sessions#new
#                member_session POST   /member/sign_in(.:format)                                                                member/sessions#create
#        destroy_member_session DELETE /member/sign_out(.:format)                                                               member/sessions#destroy
#           new_member_password GET    /member/password/new(.:format)                                                           devise/passwords#new
#          edit_member_password GET    /member/password/edit(.:format)                                                          devise/passwords#edit
#               member_password PATCH  /member/password(.:format)                                                               devise/passwords#update
#                               PUT    /member/password(.:format)                                                               devise/passwords#update
#                               POST   /member/password(.:format)                                                               devise/passwords#create
#    cancel_member_registration GET    /member/cancel(.:format)                                                                 member/registrations#cancel
#       new_member_registration GET    /member/sign_up(.:format)                                                                member/registrations#new
#      edit_member_registration GET    /member/edit(.:format)                                                                   member/registrations#edit
#           member_registration PATCH  /member(.:format)                                                                        member/registrations#update
#                               PUT    /member(.:format)                                                                        member/registrations#update
#                               DELETE /member(.:format)                                                                        member/registrations#destroy
#                               POST   /member(.:format)                                                                        member/registrations#create
#             new_member_unlock GET    /member/unlock/new(.:format)                                                             devise/unlocks#new
#                 member_unlock GET    /member/unlock(.:format)                                                                 devise/unlocks#show
#                               POST   /member/unlock(.:format)                                                                 devise/unlocks#create
#                   member_root GET    /mygatherings(.:format)                                                                  members#mygatherings
#                   memberships GET    /memberships(.:format)                                                                   memberships#index
#                               POST   /memberships(.:format)                                                                   memberships#create
#                new_membership GET    /memberships/new(.:format)                                                               memberships#new
#               edit_membership GET    /memberships/:id/edit(.:format)                                                          memberships#edit
#                    membership GET    /memberships/:id(.:format)                                                               memberships#show
#                               PATCH  /memberships/:id(.:format)                                                               memberships#update
#                               PUT    /memberships/:id(.:format)                                                               memberships#update
#                               DELETE /memberships/:id(.:format)                                                               memberships#destroy
#            member_preferences GET    /members/:member_id/preferences(.:format)                                                preferences#index
#                   edit_member GET    /members/:id/edit(.:format)                                                              members#edit
#                        member GET    /members/:id(.:format)                                                                   members#show
#                               PATCH  /members/:id(.:format)                                                                   members#update
#                               PUT    /members/:id(.:format)                                                                   members#update
#                               DELETE /members/:id(.:format)                                                                   members#destroy
#            search_preferences GET    /preferences/search(.:format)                                                            preferences#search
#       add_preference_taggings PUT    /preferences/:preference_id/taggings/add(.:format)                                       taggings#add
#                               PATCH  /preferences/:preference_id/taggings/add(.:format)                                       taggings#add
#    remove_preference_taggings DELETE /preferences/:preference_id/taggings/remove(.:format)                                    taggings#remove
#       set_preference_taggings POST   /preferences/:preference_id/taggings/set(.:format)                                       taggings#set
#           preference_taggings GET    /preferences/:preference_id/taggings(.:format)                                           taggings#index
#                               POST   /preferences/:preference_id/taggings(.:format)                                           taggings#create
#        new_preference_tagging GET    /preferences/:preference_id/taggings/new(.:format)                                       taggings#new
#                  edit_tagging GET    /taggings/:id/edit(.:format)                                                             taggings#edit
#                       tagging GET    /taggings/:id(.:format)                                                                  taggings#show
#                               PATCH  /taggings/:id(.:format)                                                                  taggings#update
#                               PUT    /taggings/:id(.:format)                                                                  taggings#update
#                               DELETE /taggings/:id(.:format)                                                                  taggings#destroy
#                   preferences GET    /preferences(.:format)                                                                   preferences#index
#                               POST   /preferences(.:format)                                                                   preferences#create
#                new_preference GET    /preferences/new(.:format)                                                               preferences#new
#               edit_preference GET    /preferences/:id/edit(.:format)                                                          preferences#edit
#                    preference GET    /preferences/:id(.:format)                                                               preferences#show
#                               PATCH  /preferences/:id(.:format)                                                               preferences#update
#                               PUT    /preferences/:id(.:format)                                                               preferences#update
#                               DELETE /preferences/:id(.:format)                                                               preferences#destroy
#    meeting_attendance_records GET    /meetings/:meeting_id/attendance(.:format)                                               attendance_records#index
#                               POST   /meetings/:meeting_id/attendance(.:format)                                               attendance_records#create
# new_meeting_attendance_record GET    /meetings/:meeting_id/attendance/new(.:format)                                           attendance_records#new
#        edit_attendance_record GET    /attendance/:id/edit(.:format)                                                           attendance_records#edit
#             attendance_record GET    /attendance/:id(.:format)                                                                attendance_records#show
#                               PATCH  /attendance/:id(.:format)                                                                attendance_records#update
#                               PUT    /attendance/:id(.:format)                                                                attendance_records#update
#                               DELETE /attendance/:id(.:format)                                                                attendance_records#destroy
#            gathering_meetings GET    /gatherings/:gathering_id/meetings(.:format)                                             meetings#index
#                  edit_meeting GET    /meetings/:id/edit(.:format)                                                             meetings#edit
#                       meeting GET    /meetings/:id(.:format)                                                                  meetings#show
#                               PATCH  /meetings/:id(.:format)                                                                  meetings#update
#                               PUT    /meetings/:id(.:format)                                                                  meetings#update
#                               DELETE /meetings/:id(.:format)                                                                  meetings#destroy
#  attendance_gathering_reports GET    /gatherings/:gathering_id/reports/attendance(.:format)                                   reports#attendance
#             gathering_reports GET    /gatherings/:gathering_id/reports(.:format)                                              reports#show
#         gathering_memberships GET    /gatherings/:gathering_id/memberships(.:format)                                          memberships#index
#                               POST   /gatherings/:gathering_id/memberships(.:format)                                          memberships#create
#      new_gathering_membership GET    /gatherings/:gathering_id/memberships/new(.:format)                                      memberships#new
#                               GET    /memberships/:id/edit(.:format)                                                          memberships#edit
#                               GET    /memberships/:id(.:format)                                                               memberships#show
#                               PATCH  /memberships/:id(.:format)                                                               memberships#update
#                               PUT    /memberships/:id(.:format)                                                               memberships#update
#                               DELETE /memberships/:id(.:format)                                                               memberships#destroy
#             gathering_members GET    /gatherings/:gathering_id/members(.:format)                                              members#index
#                accept_request POST   /requests/:id/accept(.:format)                                                           requests#accept
#                answer_request POST   /requests/:id/answer(.:format)                                                           requests#answer
#               dismiss_request POST   /requests/:id/dismiss(.:format)                                                          requests#dismiss
#            gathering_requests GET    /gatherings/:gathering_id/requests(.:format)                                             requests#index
#                               POST   /gatherings/:gathering_id/requests(.:format)                                             requests#create
#         new_gathering_request GET    /gatherings/:gathering_id/requests/new(.:format)                                         requests#new
#                  edit_request GET    /requests/:id/edit(.:format)                                                             requests#edit
#                       request GET    /requests/:id(.:format)                                                                  requests#show
#                               PATCH  /requests/:id(.:format)                                                                  requests#update
#                               PUT    /requests/:id(.:format)                                                                  requests#update
#                               DELETE /requests/:id(.:format)                                                                  requests#destroy
#      search_campus_gatherings GET    /campuses/:campus_id/gatherings/search(.:format)                                         gatherings#search
#        add_gathering_taggings PUT    /gatherings/:gathering_id/taggings/add(.:format)                                         taggings#add
#                               PATCH  /gatherings/:gathering_id/taggings/add(.:format)                                         taggings#add
#     remove_gathering_taggings DELETE /gatherings/:gathering_id/taggings/remove(.:format)                                      taggings#remove
#        set_gathering_taggings POST   /gatherings/:gathering_id/taggings/set(.:format)                                         taggings#set
#            gathering_taggings GET    /gatherings/:gathering_id/taggings(.:format)                                             taggings#index
#                               POST   /gatherings/:gathering_id/taggings(.:format)                                             taggings#create
#         new_gathering_tagging GET    /gatherings/:gathering_id/taggings/new(.:format)                                         taggings#new
#                               GET    /taggings/:id/edit(.:format)                                                             taggings#edit
#                               GET    /taggings/:id(.:format)                                                                  taggings#show
#                               PATCH  /taggings/:id(.:format)                                                                  taggings#update
#                               PUT    /taggings/:id(.:format)                                                                  taggings#update
#                               DELETE /taggings/:id(.:format)                                                                  taggings#destroy
#             campus_gatherings GET    /campuses/:campus_id/gatherings(.:format)                                                gatherings#index
#                               POST   /campuses/:campus_id/gatherings(.:format)                                                gatherings#create
#          new_campus_gathering GET    /campuses/:campus_id/gatherings/new(.:format)                                            gatherings#new
#                edit_gathering GET    /gatherings/:id/edit(.:format)                                                           gatherings#edit
#                     gathering GET    /gatherings/:id(.:format)                                                                gatherings#show
#                               PATCH  /gatherings/:id(.:format)                                                                gatherings#update
#                               PUT    /gatherings/:id(.:format)                                                                gatherings#update
#                               DELETE /gatherings/:id(.:format)                                                                gatherings#destroy
#     attendance_campus_reports GET    /campuses/:campus_id/reports/attendance(.:format)                                        reports#attendance
#            gap_campus_reports GET    /campuses/:campus_id/reports/gap(.:format)                                               reports#gap
#                campus_reports GET    /campuses/:campus_id/reports(.:format)                                                   reports#show
#            campus_memberships GET    /campuses/:campus_id/memberships(.:format)                                               memberships#index
#                               POST   /campuses/:campus_id/memberships(.:format)                                               memberships#create
#         new_campus_membership GET    /campuses/:campus_id/memberships/new(.:format)                                           memberships#new
#                               GET    /memberships/:id/edit(.:format)                                                          memberships#edit
#                               GET    /memberships/:id(.:format)                                                               memberships#show
#                               PATCH  /memberships/:id(.:format)                                                               memberships#update
#                               PUT    /memberships/:id(.:format)                                                               memberships#update
#                               DELETE /memberships/:id(.:format)                                                               memberships#destroy
#                campus_members GET    /campuses/:campus_id/members(.:format)                                                   members#index
#                               POST   /requests/:id/accept(.:format)                                                           requests#accept
#                               POST   /requests/:id/answer(.:format)                                                           requests#answer
#                               POST   /requests/:id/dismiss(.:format)                                                          requests#dismiss
#               campus_requests GET    /campuses/:campus_id/requests(.:format)                                                  requests#index
#                               POST   /campuses/:campus_id/requests(.:format)                                                  requests#create
#            new_campus_request GET    /campuses/:campus_id/requests/new(.:format)                                              requests#new
#                               GET    /requests/:id/edit(.:format)                                                             requests#edit
#                               GET    /requests/:id(.:format)                                                                  requests#show
#                               PATCH  /requests/:id(.:format)                                                                  requests#update
#                               PUT    /requests/:id(.:format)                                                                  requests#update
#                               DELETE /requests/:id(.:format)                                                                  requests#destroy
#            community_campuses GET    /communities/:community_id/campuses(.:format)                                            campuses#index
#                               POST   /communities/:community_id/campuses(.:format)                                            campuses#create
#          new_community_campus GET    /communities/:community_id/campuses/new(.:format)                                        campuses#new
#                   edit_campus GET    /campuses/:id/edit(.:format)                                                             campuses#edit
#                        campus GET    /campuses/:id(.:format)                                                                  campuses#show
#                               PATCH  /campuses/:id(.:format)                                                                  campuses#update
#                               PUT    /campuses/:id(.:format)                                                                  campuses#update
#                               DELETE /campuses/:id(.:format)                                                                  campuses#destroy
#   search_community_gatherings GET    /communities/:community_id/gatherings/search(.:format)                                   gatherings#search
#          community_gatherings GET    /communities/:community_id/gatherings(.:format)                                          gatherings#index
#  search_community_preferences GET    /communities/:community_id/preferences/search(.:format)                                  preferences#search
#         community_preferences GET    /communities/:community_id/preferences(.:format)                                         preferences#index
#                               POST   /communities/:community_id/preferences(.:format)                                         preferences#create
#      new_community_preference GET    /communities/:community_id/preferences/new(.:format)                                     preferences#new
#                               GET    /preferences/:id/edit(.:format)                                                          preferences#edit
#                               GET    /preferences/:id(.:format)                                                               preferences#show
#                               PATCH  /preferences/:id(.:format)                                                               preferences#update
#                               PUT    /preferences/:id(.:format)                                                               preferences#update
#                               DELETE /preferences/:id(.:format)                                                               preferences#destroy
#  attendance_community_reports GET    /communities/:community_id/reports/attendance(.:format)                                  reports#attendance
#         gap_community_reports GET    /communities/:community_id/reports/gap(.:format)                                         reports#gap
#             community_reports GET    /communities/:community_id/reports(.:format)                                             reports#show
#            community_requests GET    /communities/:community_id/requests(.:format)                                            requests#index
#                  tag_set_tags GET    /tag_sets/:tag_set_id/tags(.:format)                                                     tags#index
#                               POST   /tag_sets/:tag_set_id/tags(.:format)                                                     tags#create
#               new_tag_set_tag GET    /tag_sets/:tag_set_id/tags/new(.:format)                                                 tags#new
#                      edit_tag GET    /tags/:id/edit(.:format)                                                                 tags#edit
#                           tag GET    /tags/:id(.:format)                                                                      tags#show
#                               PATCH  /tags/:id(.:format)                                                                      tags#update
#                               PUT    /tags/:id(.:format)                                                                      tags#update
#                               DELETE /tags/:id(.:format)                                                                      tags#destroy
#            community_tag_sets GET    /communities/:community_id/tag_sets(.:format)                                            tag_sets#index
#                               POST   /communities/:community_id/tag_sets(.:format)                                            tag_sets#create
#         new_community_tag_set GET    /communities/:community_id/tag_sets/new(.:format)                                        tag_sets#new
#                  edit_tag_set GET    /tag_sets/:id/edit(.:format)                                                             tag_sets#edit
#                       tag_set GET    /tag_sets/:id(.:format)                                                                  tag_sets#show
#                               PATCH  /tag_sets/:id(.:format)                                                                  tag_sets#update
#                               PUT    /tag_sets/:id(.:format)                                                                  tag_sets#update
#                               DELETE /tag_sets/:id(.:format)                                                                  tag_sets#destroy
#         community_memberships GET    /communities/:community_id/memberships(.:format)                                         memberships#index
#                               POST   /communities/:community_id/memberships(.:format)                                         memberships#create
#      new_community_membership GET    /communities/:community_id/memberships/new(.:format)                                     memberships#new
#                               GET    /memberships/:id/edit(.:format)                                                          memberships#edit
#                               GET    /memberships/:id(.:format)                                                               memberships#show
#                               PATCH  /memberships/:id(.:format)                                                               memberships#update
#                               PUT    /memberships/:id(.:format)                                                               memberships#update
#                               DELETE /memberships/:id(.:format)                                                               memberships#destroy
#             community_members GET    /communities/:community_id/members(.:format)                                             members#index
#                   communities GET    /communities(.:format)                                                                   communities#index
#                               POST   /communities(.:format)                                                                   communities#create
#                 new_community GET    /communities/new(.:format)                                                               communities#new
#                edit_community GET    /communities/:id/edit(.:format)                                                          communities#edit
#                     community GET    /communities/:id(.:format)                                                               communities#show
#                               PATCH  /communities/:id(.:format)                                                               communities#update
#                               PUT    /communities/:id(.:format)                                                               communities#update
#                               DELETE /communities/:id(.:format)                                                               communities#destroy
#            rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
#     rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#            rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
#     update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#          rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create

Rails.application.routes.draw do
  JOINABLE_TYPES = [Community, Campus, Gathering].map{|o| o.to_s.tableize}.join('|')

  concern :attendance_reportable do
    get 'attendance', to: 'reports#attendance'
  end

  concern :gap_reportable do
    get 'gap', to: 'reports#gap'
  end

  concern :joinable do
    resources :memberships, shallow: true
    resources :members, only: [:index]
  end

  concern :requestable do
    resources :requests, shallow: true do
      member do
        post "accept", action: "accept"
        post "answer", action: "answer"
        post "dismiss", action: "dismiss"
      end
    end
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

  # root 'welcome#index'
  # get 'welcome', to: 'welcome#index', as: :welcome
 
  devise_scope :member do
    root 'member/sessions#new'
    get 'welcome', to: 'member/sessions#new', as: :welcome

    get 'signup', to: 'member/registrations#signup'
    get 'signin', to: 'member/sessions#new'
    delete 'signout', to: 'member/sessions#destroy'
  end
  devise_for :member, controllers: {
    registrations: 'member/registrations',
    sessions: 'member/sessions'
  }
  get 'mygatherings', to: 'members#mygatherings', as: :member_root

  resources :memberships
  resources :members, only: [:show, :edit, :update, :destroy] do
    resources :preferences, shallow: true, only: [:index]
  end
  resources :preferences, concerns: [:searchable, :taggable]

  resources :communities, concerns: [:joinable] do

    resources :campuses, shallow: true, concerns: [:joinable, :requestable] do

      resources :gatherings, shallow: true, concerns: [:joinable, :requestable, :searchable, :taggable] do

        resources :meetings, shallow: true, except: [:create, :new] do
          resources :attendance_records, path: :attendance
        end

        resource :reports, concerns: [:attendance_reportable], only: [:show]
      end

      resource :reports, concerns: [:attendance_reportable, :gap_reportable], only: [:show]
    end

    resources :gatherings, shallow: true, only: [:index], concerns: [:searchable]
    resources :preferences, shallow: true, concerns: [:searchable]
    resource :reports, concerns: [:attendance_reportable, :gap_reportable], only: [:show]
    resources :requests, only: [:index]
    resources :tag_sets, shallow: true do
      resources :tags
    end

  end

end
