# Routes

                              Prefix Verb   URI Pattern                                             Controller#Action
                                root GET    /                                                       welcome#index
                         member_root GET    /mygatherings(.:format)                                 members#mygatherings
                             welcome GET    /welcome(.:format)                                      welcome#index
                             
                             sign_up GET    /sign_up(.:format)                                      member/registrations#new
                             sign_in GET    /sign_in(.:format)                                      devise/sessions#new
                            sign_out DELETE /sign_out(.:format)                                     devise/sessions#destroy

                  new_member_session GET    /member/sign_in(.:format)                               devise/sessions#new
                      member_session POST   /member/sign_in(.:format)                               devise/sessions#create
              destroy_member_session DELETE /member/sign_out(.:format)                              devise/sessions#destroy

                 new_member_password GET    /member/password/new(.:format)                          devise/passwords#new
                edit_member_password GET    /member/password/edit(.:format)                         devise/passwords#edit
                     member_password POST   /member/password(.:format)                              devise/passwords#create
                                     PATCH  /member/password(.:format)                              devise/passwords#update
                                     PUT    /member/password(.:format)                              devise/passwords#update

             new_member_registration GET    /member/sign_up(.:format)                               member/registrations#new
          cancel_member_registration GET    /member/cancel(.:format)                                member/registrations#cancel
            edit_member_registration GET    /member/edit(.:format)                                  member/registrations#edit
            show_member_registration GET    /member(.:format)                                       member/registrations#show
                 member_registration POST   /member(.:format)                                       member/registrations#create
                                     PATCH  /member(.:format)                                       member/registrations#update
                                     PUT    /member(.:format)                                       member/registrations#update
                                     DELETE /member(.:format)                                       member/registrations#destroy

                   new_member_unlock GET    /member/unlock/new(.:format)                            devise/unlocks#new
                       member_unlock POST   /member/unlock(.:format)                                devise/unlocks#create
                                     GET    /member/unlock(.:format)                                devise/unlocks#show

                     edit_membership GET    /memberships/:id/edit(.:format)                         memberships#edit
                          membership GET    /memberships/:id(.:format)                              memberships#show
                                     PATCH  /memberships/:id(.:format)                              memberships#update
                                     PUT    /memberships/:id(.:format)                              memberships#update
                                     DELETE /memberships/:id(.:format)                              memberships#destroy

                edit_membership_tags GET    /memberships/:membership_id/tags/edit(.:format)         tags#edit
                     membership_tags PATCH  /memberships/:membership_id/tags(.:format)              tags#update
                                     PUT    /memberships/:membership_id/tags(.:format)              tags#update

                       new_community GET    /communities/new(.:format)                              communities#new
                      edit_community GET    /communities/:id/edit(.:format)                         communities#edit
                         communities GET    /communities(.:format)                                  communities#index
                                     POST   /communities(.:format)                                  communities#create

                           community GET    /communities/:id(.:format)                              communities#show
                                     PATCH  /communities/:id(.:format)                              communities#update
                                     PUT    /communities/:id(.:format)                              communities#update
                                     DELETE /communities/:id(.:format)                              communities#destroy

                new_community_campus GET    /communities/:community_id/campuses/new(.:format)       campuses#new
                  community_campuses GET    /communities/:community_id/campuses(.:format)           campuses#index
                                     POST   /communities/:community_id/campuses(.:format)           campuses#create

             new_community_gathering GET    /communities/:community_id/gatherings/new(.:format)     gatherings#new
         search_community_gatherings GET    /communities/:community_id/gatherings/search(.:format)  gatherings#search
                community_gatherings GET    /communities/:community_id/gatherings(.:format)         gatherings#index
                                     POST   /communities/:community_id/gatherings(.:format)         gatherings#create

                new_community_member GET    /communities/:community_id/members/new(.:format)        members#new
                   community_members GET    /communities/:community_id/members(.:format)            members#index
                                     POST   /communities/:community_id/members(.:format)            members#create

               edit_community_member GET    /communities/:community_id/members/:id/edit(.:format)   members#edit
                    community_member GET    /communities/:community_id/members/:id(.:format)        members#show
                                     PATCH  /communities/:community_id/members/:id(.:format)        members#update
                                     PUT    /communities/:community_id/members/:id(.:format)        members#update
                                     DELETE /communities/:community_id/members/:id(.:format)        members#destroy

            new_community_membership GET    /communities/:community_id/memberships/new(.:format)    memberships#new
               community_memberships GET    /communities/:community_id/memberships(.:format)        memberships#index
                                     POST   /communities/:community_id/memberships(.:format)        memberships#create

                   community_reports GET    /communities/:community_id/reports(.:format)            reports#show
        attendance_community_reports GET    /communities/:community_id/reports/attendance(.:format) reports#attendance
               gap_community_reports GET    /communities/:community_id/reports/gap(.:format)        reports#gap

                         edit_campus GET    /campuses/:id/edit(.:format)                            campuses#edit
                              campus GET    /campuses/:id(.:format)                                 campuses#show
                                     PATCH  /campuses/:id(.:format)                                 campuses#update
                                     PUT    /campuses/:id(.:format)                                 campuses#update
                                     DELETE /campuses/:id(.:format)                                 campuses#destroy

               new_campus_membership GET    /campuses/:campus_id/memberships/new(.:format)          memberships#new
                  campus_memberships GET    /campuses/:campus_id/memberships(.:format)              memberships#index
                                     POST   /campuses/:campus_id/memberships(.:format)              memberships#create

                      campus_reports GET    /campuses/:campus_id/reports(.:format)                  reports#show
           attendance_campus_reports GET    /campuses/:campus_id/reports/attendance(.:format)       reports#attendance
                  gap_campus_reports GET    /campuses/:campus_id/reports/gap(.:format)              reports#gap

                      edit_gathering GET    /gatherings/:id/edit(.:format)                          gatherings#edit
                           gathering GET    /gatherings/:id(.:format)                               gatherings#show
                                     PATCH  /gatherings/:id(.:format)                               gatherings#update
                                     PUT    /gatherings/:id(.:format)                               gatherings#update
                                     DELETE /gatherings/:id(.:format)                               gatherings#destroy

                  gathering_meetings GET    /gatherings/:gathering_id/meetings(.:format)            meetings#index
                                     POST   /gatherings/:gathering_id/meetings(.:format)            meetings#create

            new_gathering_membership GET    /gatherings/:gathering_id/memberships/new(.:format)     memberships#new
               gathering_memberships GET    /gatherings/:gathering_id/memberships(.:format)         memberships#index
                                     POST   /gatherings/:gathering_id/memberships(.:format)         memberships#create

                   gathering_reports GET    /gatherings/:gathering_id/reports(.:format)             reports#show
        attendance_gathering_reports GET    /gatherings/:gathering_id/reports/attendance(.:format)  reports#attendance

    new_gathering_membership_request GET    /gatherings/:gathering_id/requests/new(.:format)        membership_requests#new
       gathering_membership_requests GET    /gatherings/:gathering_id/requests(.:format)            membership_requests#index
                                     POST   /gatherings/:gathering_id/requests(.:format)            membership_requests#create

                 edit_gathering_tags GET    /gatherings/:gathering_id/tags/edit(.:format)           tags#edit
                      gathering_tags PATCH  /gatherings/:gathering_id/tags(.:format)                tags#update
                                     PUT    /gatherings/:gathering_id/tags(.:format)                tags#update

              edit_attendance_record GET    /attendance/:id/edit(.:format)                          attendance_records#edit
                   attendance_record GET    /attendance/:id(.:format)                               attendance_records#show
                                     PATCH  /attendance/:id(.:format)                               attendance_records#update
                                     PUT    /attendance/:id(.:format)                               attendance_records#update
                                     DELETE /attendance/:id(.:format)                               attendance_records#destroy

                        edit_meeting GET    /meetings/:id/edit(.:format)                            meetings#edit
                             meeting GET    /meetings/:id(.:format)                                 meetings#show
                                     PATCH  /meetings/:id(.:format)                                 meetings#update
                                     PUT    /meetings/:id(.:format)                                 meetings#update
                                     DELETE /meetings/:id(.:format)                                 meetings#destroy

       new_meeting_attendance_record GET    /meetings/:meeting_id/attendance/new(.:format)          attendance_records#new
          meeting_attendance_records GET    /meetings/:meeting_id/attendance(.:format)              attendance_records#index
                                     POST   /meetings/:meeting_id/attendance(.:format)              attendance_records#create

           accept_membership_request POST   /requests/:id/accept(.:format)                          membership_requests#accept
           answer_membership_request POST   /requests/:id/answer(.:format)                          membership_requests#answer
          dismiss_membership_request POST   /requests/:id/dismiss(.:format)                         membership_requests#dismiss
             edit_membership_request GET    /requests/:id/edit(.:format)                            membership_requests#edit
                  membership_request GET    /requests/:id(.:format)                                 membership_requests#show
                                     PATCH  /requests/:id(.:format)                                 membership_requests#update
                                     PUT    /requests/:id(.:format)                                 membership_requests#update
                                     DELETE /requests/:id(.:format)                                 membership_requests#destroy
