class GatheringsController < ApplicationController
  include Sequencer

  sequence_of :create, :location, :age_group, :life_stage, :relationship, :gender

  prepend_before_action :set_community
  before_action :set_gathering, only: [:show, :destroy]

  # GET /gatherings
  # GET /gatherings.json
  def index
    @gatherings = Gathering.all
  end

  # GET /gatherings/1
  # GET /gatherings/1.json
  def show
  end

  # DELETE /gatherings/1
  # DELETE /gatherings/1.json
  def destroy
    @gathering.destroy
    respond_to do |format|
      format.html { redirect_to community_gatherings_url, notice: 'Gathering was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def gathering_params
      params.require(:gathering).permit(:name, :description, *Gathering.address_fields, :meeting_starts, :meeting_ends, :meeting_day, :meeting_time, :meeting_duration)
    end

    def set_community
      @community = Community.find(params[:community_id])
    end

    def set_gathering
      @gathering = Gathering.find(params[:id]) if params.include?(:id)
    end

    def sequence_complete
      respond_to do |format|
        format.html { redirect_to community_gathering_url(@community, @gathering) }
      end
    end

    def sequence_step_params
      case @sequence_step
      when :create, :location
        gathering_params
      else
        params.require(:gathering).permit("#{@sequence_step}_list".to_sym => [])
      end
    end

    def sequence_prepare_step
      if (2...self.class.sequence_steps.length).include?(@sequence_step_index)
        @collection = @gathering.class.send("#{@sequence_step}s_collection".to_sym)
        @collection_member = "#{@sequence_step}_list".to_sym
      end
    end

    def sequence_variable_factory
      Gathering.new(community: @community)
    end

end
