# require 'rails_helper'

# describe CommunitiesController, type: :controller do

#   before :all do
#     @member = create(:member)
#     @communities = []
#     10.times { @communities << create(:community) }
#   end

#   after :all do
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
#       get :index
#       expect(response).to be_successful
#       expect(response).to have_http_status(200)
#     end

#     it 'renders the index template' do
#       get :index
#       expect(response).to render_template("index")
#     end

#     it 'loads all Communities into @communities' do
#       get :index
#       expect(assigns(:communities)).to match_array(@communities)
#     end
#   end

#   describe "GET #show" do
#     it 'responds with HTTP 200' do
#       get :show, params: { id: @communities.first.id }
#       expect(response).to be_successful
#       expect(response).to have_http_status(200)
#     end

#     it 'renders the show template' do
#       get :show, params: { id: @communities.first.id }
#       expect(response).to render_template("show")
#     end

#     it 'loads all Communities into @communities' do
#       get :show, params: { id: @communities.first.id }
#       expect(assigns(:community)).to eq(@communities.first)
#     end
#   end

# end
