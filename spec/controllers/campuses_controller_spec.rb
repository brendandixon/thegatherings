# == Schema Information
#
# Table name: campuses
#
#  id               :integer          not null, primary key
#  community_id     :integer          not null
#  name             :string(255)
#  email            :string(255)
#  phone            :string(255)
#  street_primary   :string(255)
#  street_secondary :string(255)
#  city             :string(255)
#  state            :string(255)
#  postal_code      :string(255)
#  time_zone        :string(255)
#  country          :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  active_on        :datetime
#  inactive_on      :datetime
#

require 'rails_helper'

describe CampusesController, type: :controller do

  before :all do
    @member = create(:member)

    @community = create(:community)
    @campuses = []
    10.times { @campuses << create(:campus, community: @community) }

    create(:membership, :as_administrator, member: @member, group: @community)
  end

  after :all do
    Campus.delete_all
    Community.delete_all
    Member.delete_all
  end

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @member
  end

  after :each do
    sign_out @member
  end

  describe "GET #index" do
    it 'responds with HTTP 200' do
      get :index, params: {community_id: @community.id}
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders the index template' do
      get :index, params: {community_id: @community.id}
      expect(response).to render_template("index")
    end

    it 'loads all Campuses into @campuses' do
      get :index, params: {community_id: @community.id}
      expect(assigns(:campuses)).to match_array(@campuses)
    end
  end

  describe "GET #show" do
    it 'responds with HTTP 200' do
      get :show, params: { id: @campuses.first.id }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders the show template' do
      get :show, params: { id: @campuses.first.id }
      expect(response).to render_template("show")
    end

    it 'loads all Campuses into @campuses' do
      get :show, params: { id: @campuses.first.id }
      expect(assigns(:campus)).to eq(@campuses.first)
    end
  end

  describe "GET #new" do
    it 'responds with HTTP 200' do
      get :new, params: { community_id: @community.id }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders the new template' do
      get :new, params: { community_id: @community.id }
      expect(response).to render_template("new")
    end

    it 'loads a new Campus into @campus' do
      get :new, params: { community_id: @community.id }
      expect(assigns(:campus)).to be_a_new(Campus)
    end
  end

end
