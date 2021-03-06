class TagsController < ApplicationController

  before_action :set_tag, except: COLLECTION_ACTIONS
  before_action :set_category
  before_action :set_community
  before_action :ensure_authorized

  def index
    @tags = @category.tags
    respond_to do |format|
      format.html { render }
      format.json { render json: @tags.as_json(deep: true) }
    end
  end

  def show
    respond_to do |format|
      format.html { render }
      format.json { render json: @tag.as_json(deep: true) }
    end
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @tag.save
        format.html { redirect_to tag_path(@tag), notice: 'Tag was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @tag.attributes = tag_params[:category]
    ensure_authorized
    respond_to do |format|
      if @tag.save
        format.html { redirect_to tag_path(@tag), notice: 'Tag was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to tag_path(@tag), notice: 'Tag was successfully destroyed.' }
    end
  end

  private

    def ensure_authorized
      authorize_action_for @community
    end

    def set_community
      @community = @category.community if @category.present?
      redirect_to root_path unless @community.present?
    end

    def set_tag
      @tag = Tag.find(params[:id]) rescue nil if params[:id].present?
      @tag ||= Tag.new(tag_params[:tag])
    end

    def set_category
      @category = Category.find(params[:category_id]) rescue nil if params[:category_id].present?
    end

    def tag_params
      params.permit(tags: Tag::FORM_FIELDS)
    end

end
