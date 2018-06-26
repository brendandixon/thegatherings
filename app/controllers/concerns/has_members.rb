module HasMembers
  extend ActiveSupport::Concern

  included do
  end

  class_methods do
  end

  protected

    def ensure_member
      @member ||= current_member
    end

    def set_member
      @member = Member.find(params[:member_id]) rescue nil if params[:member_id].present?
    end

end
