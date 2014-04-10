module SelectedStatusHandler
  def save_selected_status(status100)
    # puts '- saving [selected_status]' if BW::debug?
    app_delegate.current_status100 = status100
  end

  # @return [SelectedStatus100]
  def loaded_selected_status
    # puts '- loading [selected_status]' if BW::debug?
    status100 = app_delegate.current_status100
    case status100
      when nil ; nil
      else
        status100
    end
  end

end