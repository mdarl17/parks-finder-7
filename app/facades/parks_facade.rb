class ParksFacade
  def initialize(state_code)
    @state_code = state_code.upcase
  end

  include ApplicationHelper

  def state_code_to_name
    code_to_name_hash = us_states.map(&:reverse).to_h
    code_to_name_hash[@state_code]
  end
end