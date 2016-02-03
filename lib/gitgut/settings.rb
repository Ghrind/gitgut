require 'settingslogic'

module Gitgut
  # Application-wide settings accessor
  #
  # It reads the .gitgut in the runtime directory
  class Settings < Settingslogic
    source '.gitgut'
  end
end
