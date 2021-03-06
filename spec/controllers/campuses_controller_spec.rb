# require 'rails_helper'

# describe CampusesController, type: :controller do

#   before :all do
#     @member = create(:member)

#     @community = create(:community)
#     @campuses = []
#     10.times { @campuses << create(:campus, community: @community) }

#     create(:membership, :as_leader, member: @member, group: @community)
#   end

#   after :all do
#     Campus.delete_all
#     Community.delete_all
#     Member.delete_all
#   end

#   before :each do
#     @request.env["devise.mapping"] = Devise.mappings[:user]
#     sign_in @member
#   end

#   after :each do
#     sign_out @member
#   end

#   describe "GET #index" do
#     it 'responds with HTTP 200' do
#       get :index, params: {community_id: @community.id}
#       expect(response).to be_successful
#       expect(response).to have_http_status(200)
#     end

#     it 'renders the index template' do
#       get :index, params: {community_id: @community.id}
#       expect(response).to render_template("index")
#     end

#     it 'loads all Campuses into @campuses' do
#       get :index, params: {community_id: @community.id}
#       expect(assigns(:campuses)).to match_array(@campuses)
#     end
#   end

#   describe "GET #show" do
#     it 'responds with HTTP 200' do
#       get :show, params: { id: @campuses.first.id }
#       expect(response).to be_successful
#       expect(response).to have_http_status(200)
#     end

#     it 'renders the show template' do
#       get :show, params: { id: @campuses.first.id }
#       expect(response).to render_template("show")
#     end

#     it 'loads all Campuses into @campuses' do
#       get :show, params: { id: @campuses.first.id }
#       expect(assigns(:campus)).to eq(@campuses.first)
#     end
#   end

#   describe "GET #new" do
#     it 'responds with HTTP 200' do
#       get :new, params: { community_id: @community.id }
#       expect(response).to be_successful
#       expect(response).to have_http_status(200)
#     end

#     it 'renders the new template' do
#       get :new, params: { community_id: @community.id }
#       expect(response).to render_template("new")
#     end

#     it 'loads a new Campus into @campus' do
#       get :new, params: { community_id: @community.id }
#       expect(assigns(:campus)).to be_a_new(Campus)
#     end
#   end

# end
