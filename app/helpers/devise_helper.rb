module DeviseHelper

  def is_devise_confirmable?
    devise_mapping.confirmable? &&
    controller_name != 'confirmations'
  end

  def is_devise_omniauthable?
    devise_mapping.omniauthable?
  end

  def is_devise_recoverable?
    devise_mapping.recoverable? &&
    controller_name != 'passwords' &&
    controller_name != 'registrations'
  end

  def is_devise_unlockable?
    devise_mapping.lockable? &&
    resource_class.unlock_strategy_enabled?(:email) &&
    controller_name != 'unlocks'
  end

end
