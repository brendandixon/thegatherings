class CategoriesController < ApplicationController

  before_action :set_category, except: COLLECTION_ACTIONS
  before_action :set_community
  before_action :ensure_community
  before_action :ensure_authorized

  def index
    @categories = @community.categories
    respond_to do |format|
      format.html { render }
      format.json { render json: @categories.as_json(deep: true) }
    end
  end

  def show
    respond_to do |format|
      format.html { render }
      format.json { render json: @category.as_json(deep: true) }
    end
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @category.save
        format.html { redirect_to category_path(@category), notice: 'Tag set was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @category.attributes = category_params[:category]
    ensure_authorized
    respond_to do |format|
      if @category.save
        format.html { redirect_to category_path(@category), notice: 'Tag set was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to category_path(@category), notice: 'Tag set was successfully destroyed.' }
    end
  end

  private

    def ensure_authorized
      perspective = is_perspective_action? ? :as_anyone : :as_member
      authorize_action_for @community, perspective: perspective
    end

    def ensure_community
      @community ||= @category.community if @category.present?
      redirect_to member_root_path if @community.blank? || (@category.present? && @community.id != @category.community_id)
    end

    def set_category
      @category = Category.find(params[:id]) rescue nil if params[:id].present?
      @category ||= Category.new(category_params[:category])
    end

    def set_community
      @community = Community.find(params[:community_id]) rescue nil if params[:community_id].present?
      @category.community ||= @community if @category.present?
    end

    def category_params
      params.permit(category: Category::FORM_FIELDS)
    end
end
