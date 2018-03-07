# == Route Map
#
#                           Prefix Verb   URI Pattern                                             Controller#Action
#                             root GET    /                                                       welcome#index
#                          welcome GET    /welcome(.:format)                                      welcome#index
#                          sign_up GET    /sign_up(.:format)                                      member/registrations#new
#                          sign_in GET    /sign_in(.:format)                                      devise/sessions#new
#                         sign_out DELETE /sign_out(.:format)                                     devise/sessions#destroy
#         show_member_registration GET    /member(.:format)                                       member/registrations#show
#               new_member_session GET    /member/sign_in(.:format)                               devise/sessions#new
#                   member_session POST   /member/sign_in(.:format)                               devise/sessions#create
#           destroy_member_session DELETE /member/sign_out(.:format)                              devise/sessions#destroy
#              new_member_password GET    /member/password/new(.:format)                          devise/passwords#new
#             edit_member_password GET    /member/password/edit(.:format)                         devise/passwords#edit
#                  member_password PATCH  /member/password(.:format)                              devise/passwords#update
#                                  PUT    /member/password(.:format)                              devise/passwords#update
#                                  POST   /member/password(.:format)                              devise/passwords#create
#       cancel_member_registration GET    /member/cancel(.:format)                                member/registrations#cancel
#          new_member_registration GET    /member/sign_up(.:format)                               member/registrations#new
#         edit_member_registration GET    /member/edit(.:format)                                  member/registrations#edit
#              member_registration PATCH  /member(.:format)                                       member/registrations#update
#                                  PUT    /member(.:format)                                       member/registrations#update
#                                  DELETE /member(.:format)                                       member/registrations#destroy
#                                  POST   /member(.:format)                                       member/registrations#create
#                new_member_unlock GET    /member/unlock/new(.:format)                            devise/unlocks#new
#                    member_unlock GET    /member/unlock(.:format)                                devise/unlocks#show
#                                  POST   /member/unlock(.:format)                                devise/unlocks#create
#                      member_root GET    /mygatherings(.:format)                                 members#mygatherings
#         search_campus_gatherings GET    /campuses/:campus_id/gatherings/search(.:format)        gatherings#search
#       meeting_attendance_records GET    /meetings/:meeting_id/attendance(.:format)              attendance_records#index
#                                  POST   /meetings/:meeting_id/attendance(.:format)              attendance_records#create
#    new_meeting_attendance_record GET    /meetings/:meeting_id/attendance/new(.:format)          attendance_records#new
#           edit_attendance_record GET    /attendance/:id/edit(.:format)                          attendance_records#edit
#                attendance_record GET    /attendance/:id(.:format)                               attendance_records#show
#                                  PATCH  /attendance/:id(.:format)                               attendance_records#update
#                                  PUT    /attendance/:id(.:format)                               attendance_records#update
#                                  DELETE /attendance/:id(.:format)                               attendance_records#destroy
#               gathering_meetings GET    /gatherings/:gathering_id/meetings(.:format)            meetings#index
#                     edit_meeting GET    /meetings/:id/edit(.:format)                            meetings#edit
#                          meeting GET    /meetings/:id(.:format)                                 meetings#show
#                                  PATCH  /meetings/:id(.:format)                                 meetings#update
#                                  PUT    /meetings/:id(.:format)                                 meetings#update
#                                  DELETE /meetings/:id(.:format)                                 meetings#destroy
#        accept_membership_request POST   /requests/:id/accept(.:format)                          membership_requests#accept
#        answer_membership_request POST   /requests/:id/answer(.:format)                          membership_requests#answer
#       dismiss_membership_request POST   /requests/:id/dismiss(.:format)                         membership_requests#dismiss
#    gathering_membership_requests GET    /gatherings/:gathering_id/requests(.:format)            membership_requests#index
#                                  POST   /gatherings/:gathering_id/requests(.:format)            membership_requests#create
# new_gathering_membership_request GET    /gatherings/:gathering_id/requests/new(.:format)        membership_requests#new
#          edit_membership_request GET    /requests/:id/edit(.:format)                            membership_requests#edit
#               membership_request GET    /requests/:id(.:format)                                 membership_requests#show
#                                  PATCH  /requests/:id(.:format)                                 membership_requests#update
#                                  PUT    /requests/:id(.:format)                                 membership_requests#update
#                                  DELETE /requests/:id(.:format)                                 membership_requests#destroy
#                                  GET    /gatherings/:gathering_id/requests(.:format)            membership_requests#index
#            gathering_memberships GET    /gatherings/:gathering_id/memberships(.:format)         memberships#index
#                                  POST   /gatherings/:gathering_id/memberships(.:format)         memberships#create
#         new_gathering_membership GET    /gatherings/:gathering_id/memberships/new(.:format)     memberships#new
#     attendance_gathering_reports GET    /gatherings/:gathering_id/reports/attendance(.:format)  reports#attendance
#                gathering_reports GET    /gatherings/:gathering_id/reports(.:format)             reports#show
#              edit_gathering_tags GET    /gatherings/:gathering_id/tags/edit(.:format)           tags#edit
#                   gathering_tags PATCH  /gatherings/:gathering_id/tags(.:format)                tags#update
#                                  PUT    /gatherings/:gathering_id/tags(.:format)                tags#update
#                campus_gatherings GET    /campuses/:campus_id/gatherings(.:format)               gatherings#index
#                                  POST   /campuses/:campus_id/gatherings(.:format)               gatherings#create
#             new_campus_gathering GET    /campuses/:campus_id/gatherings/new(.:format)           gatherings#new
#                   edit_gathering GET    /gatherings/:id/edit(.:format)                          gatherings#edit
#                        gathering GET    /gatherings/:id(.:format)                               gatherings#show
#                                  PATCH  /gatherings/:id(.:format)                               gatherings#update
#                                  PUT    /gatherings/:id(.:format)                               gatherings#update
#                                  DELETE /gatherings/:id(.:format)                               gatherings#destroy
#               campus_memberships GET    /campuses/:campus_id/memberships(.:format)              memberships#index
#                                  POST   /campuses/:campus_id/memberships(.:format)              memberships#create
#            new_campus_membership GET    /campuses/:campus_id/memberships/new(.:format)          memberships#new
#        attendance_campus_reports GET    /campuses/:campus_id/reports/attendance(.:format)       reports#attendance
#               gap_campus_reports GET    /campuses/:campus_id/reports/gap(.:format)              reports#gap
#                   campus_reports GET    /campuses/:campus_id/reports(.:format)                  reports#show
#               community_campuses GET    /communities/:community_id/campuses(.:format)           campuses#index
#                                  POST   /communities/:community_id/campuses(.:format)           campuses#create
#             new_community_campus GET    /communities/:community_id/campuses/new(.:format)       campuses#new
#                      edit_campus GET    /campuses/:id/edit(.:format)                            campuses#edit
#                           campus GET    /campuses/:id(.:format)                                 campuses#show
#                                  PATCH  /campuses/:id(.:format)                                 campuses#update
#                                  PUT    /campuses/:id(.:format)                                 campuses#update
#                                  DELETE /campuses/:id(.:format)                                 campuses#destroy
#      search_community_gatherings GET    /communities/:community_id/gatherings/search(.:format)  gatherings#search
#             community_gatherings GET    /communities/:community_id/gatherings(.:format)         gatherings#index
#                community_members GET    /communities/:community_id/members(.:format)            members#index
#                                  POST   /communities/:community_id/members(.:format)            members#create
#             new_community_member GET    /communities/:community_id/members/new(.:format)        members#new
#                      edit_member GET    /members/:id/edit(.:format)                             members#edit
#                           member GET    /members/:id(.:format)                                  members#show
#                                  PATCH  /members/:id(.:format)                                  members#update
#                                  PUT    /members/:id(.:format)                                  members#update
#                                  DELETE /members/:id(.:format)                                  members#destroy
#            community_memberships GET    /communities/:community_id/memberships(.:format)        memberships#index
#                                  POST   /communities/:community_id/memberships(.:format)        memberships#create
#         new_community_membership GET    /communities/:community_id/memberships/new(.:format)    memberships#new
#                  edit_membership GET    /memberships/:id/edit(.:format)                         memberships#edit
#                       membership GET    /memberships/:id(.:format)                              memberships#show
#                                  PATCH  /memberships/:id(.:format)                              memberships#update
#                                  PUT    /memberships/:id(.:format)                              memberships#update
#                                  DELETE /memberships/:id(.:format)                              memberships#destroy
#             edit_preference_tags GET    /preferences/:preference_id/tags/edit(.:format)         tags#edit
#                  preference_tags PATCH  /preferences/:preference_id/tags(.:format)              tags#update
#                                  PUT    /preferences/:preference_id/tags(.:format)              tags#update
#            community_preferences GET    /communities/:community_id/preferences(.:format)        preferences#index
#                                  POST   /communities/:community_id/preferences(.:format)        preferences#create
#         new_community_preference GET    /communities/:community_id/preferences/new(.:format)    preferences#new
#                  edit_preference GET    /preferences/:id/edit(.:format)                         preferences#edit
#                       preference GET    /preferences/:id(.:format)                              preferences#show
#                                  PATCH  /preferences/:id(.:format)                              preferences#update
#                                  PUT    /preferences/:id(.:format)                              preferences#update
#                                  DELETE /preferences/:id(.:format)                              preferences#destroy
#     attendance_community_reports GET    /communities/:community_id/reports/attendance(.:format) reports#attendance
#            gap_community_reports GET    /communities/:community_id/reports/gap(.:format)        reports#gap
#                community_reports GET    /communities/:community_id/reports(.:format)            reports#show
#                      communities GET    /communities(.:format)                                  communities#index
#                                  POST   /communities(.:format)                                  communities#create
#                    new_community GET    /communities/new(.:format)                              communities#new
#                   edit_community GET    /communities/:id/edit(.:format)                         communities#edit
#                        community GET    /communities/:id(.:format)                              communities#show
#                                  PATCH  /communities/:id(.:format)                              communities#update
#                                  PUT    /communities/:id(.:format)                              communities#update
#                                  DELETE /communities/:id(.:format)                              communities#destroy

Rails.application.routes.draw do

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

    resources :campuses, shallow: true do

      resources :gatherings, shallow: true, concerns: [:taggable] do

        get 'search', on: :collection

        resources :meetings, shallow: true, except: [:create, :new] do
          resources :attendance_records, path: :attendance
        end

        resources :membership_requests, path: :requests do
          member do
            post "accept", action: "accept"
            post "answer", action: "answer"
            post "dismiss", action: "dismiss"
          end
        end

        resources :membership_requests, path: :requests, only: [:index]
        resources :memberships, shallow: true, only: [:create, :index, :new]
        resource :reports, concerns: [:attendance_reportable], only: [:show]
      end

      resources :memberships, shallow: true, only: [:create, :index, :new]
      resource :reports, concerns: [:attendance_reportable, :gap_reportable], only: [:show]
    end

    resources :gatherings, shallow: true, only: [:index] do
      get 'search', on: :collection
    end

    resources :members, shallow: true
    resources :memberships, shallow: true
    resources :preferences, shallow: true, concerns: [:taggable]
    resource :reports, concerns: [:attendance_reportable, :gap_reportable], only: [:show]
  end

end
