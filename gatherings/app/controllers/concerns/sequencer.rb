module Sequencer
  extend ActiveSupport::Concern

  included do
    cattr_accessor :sequence_controller
    cattr_accessor :sequence_cookie_name
    cattr_accessor :sequence_klass
    cattr_accessor :sequence_steps
    cattr_accessor :sequence_variable_name

    self.sequence_controller = self.name.underscore.split('_').first
    self.sequence_klass = self.sequence_controller.singularize.classify.constantize rescue nil
    self.sequence_cookie_name = "#{self.sequence_controller.singularize}_sequence"
    self.sequence_variable_name = "@#{self.sequence_controller.singularize}"

    self.sequence_steps = []

    before_action :sequence_read_step, only: [:sequence_begin_step, :sequence_complete_step]
    after_action :sequence_save_step, only: [:sequence_begin_step, :sequence_complete_step]
  end

  def sequence_begin_step
    m = "sequence_begin_#{@sequence_step}_step".to_sym
    if self.methods.include?(m)
      self.send(m)
    else
      v = self.instance_variable_get(self.class.sequence_variable_name)
      if @sequence_step_index > 0 && v.new_record?
        sequence_reset
        redirect_to url_for(controller: self.class.sequence_controller, action: :sequence_begin_step)
      elsif params[:back].present?
        sequence_step_backward
        redirect_to url_for(controller: self.class.sequence_controller, action: :sequence_begin_step, id: v.id)
      else
        respond_to do |format|
          format.html { render sequence_step_view }
        end
      end
    end
  end

  def sequence_complete_step
    m = "sequence_complete_#{@sequence_step}_step".to_sym
    if self.methods.include?(m)
      self.send(m)
    else
      v = self.instance_variable_get(self.class.sequence_variable_name)

      if v.update_attributes(sequence_step_params)
        if sequence_step_forward(params[:complete].present?)
          respond_to do |format|
            format.html { redirect_to url_for(controller: self.class.sequence_controller, action: :sequence_begin_step, id: v.id) }
          end
        else
          self.send(:sequence_complete)
        end
      else
        respond_to do |format|
          format.html { render sequence_step_view }
        end
      end
    end
  end

  def sequence_step_forward(step_to_end = false)
    @sequence_step_index = self.class.sequence_steps.length if step_to_end
    @sequence_step_index = [@sequence_step_index + 1, self.class.sequence_steps.length].min
    @sequence_step = self.class.sequence_steps[@sequence_step_index]
    @sequence_step.present?
  end

  def sequence_step_backward
    @sequence_step_index = [@sequence_step_index - 1, 0].max
    @sequence_step = self.class.sequence_steps[@sequence_step_index]
  end

  def sequence_reset
    @sequence_step_index = 0
    @sequence_step = self.class.sequence_steps[@sequence_step_index]
  end

  def sequence_read_step
    current_id = params[:id]
    v = (current_id.present? && self.sequence_klass.find(current_id) rescue nil) || self.send(:sequence_variable_factory)
    self.instance_variable_set(self.class.sequence_variable_name, v)

    last_id, last_step = cookies[self.class.sequence_cookie_name].split('|') if cookies[self.class.sequence_cookie_name].present?
    @sequence_step_index = if v.new_record? || current_id.blank? || last_id != current_id
                              0
                            else
                              last_index = self.class.sequence_steps.index(last_step.to_sym) if last_step.present?
                              last_index || 0
                            end
    @sequence_step = self.class.sequence_steps[@sequence_step_index]

    self.send(:sequence_prepare_step)
  end

  def sequence_save_step
    cookies[self.class.sequence_cookie_name] = if @sequence_step_index < 0 || @sequence_step_index >= self.class.sequence_steps.length
                                                  nil
                                               else
                                                  "#{self.instance_variable_get(self.class.sequence_variable_name).id}|#{self.class.sequence_steps[@sequence_step_index]}"
                                               end
  end

  def sequence_complete
    sequence_reset
    respond_to do |format|
      format.html { redirect_to url_for(controller: self.class.sequence_controller, action: :sequence_begin_step, id: self.instance_variable_get(self.class.sequence_variable_name).id) }
    end
  end

  def sequence_step_params
    m = "sequence_#{@sequence_step}_params".to_sym
    if self.methods.include?(m)
      self.send(m)
    end
  end

  def sequence_prepare_step
    m = "sequence_prepare_#{@sequence_step}".to_sym
    if self.methods.include?(m)
      self.send(m)
    end
  end

  def sequence_variable_factory
    self.class.new(sequence_step_params)
  end

  def sequence_step_view
    m = "sequence_#{@sequence_step}_view".to_sym
    if self.methods.include?(m)
      self.send(m)
    else
      [@sequence_step.to_s, "new_#{@sequence_step}", "step"].each do |v|
        return v if lookup_context.template_exists?(v, self.class.sequence_controller)
      end
    end
  end

  module ClassMethods

    def sequence_of(*steps)
      options = steps.extract_options!
      raise ArgumentException.new("Sequences require at least two steps") if steps.length < 2
      self.sequence_steps = steps
      self.sequence_klass = options[:klass].to_s.classify.constantize if options.include?(:klass)
    end

  end

end
