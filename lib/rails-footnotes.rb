module Footnotes

  # The footnotes are applied by default to all actions. To remove the
  # footnotes from an action, use skip_filter in your controller.
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      require 'rails-footnotes/footnotes'
      require 'rails-footnotes/backtracer'

      # Require each individual note
      notes_glob = File.expand_path("../rails-footnotes/notes/*.rb", __FILE__)
      Dir[notes_glob].each{|note| require note }

      ActionController::Base.prepend_before_filter Footnotes::BeforeFilter
      ActionController::Base.after_filter Footnotes::AfterFilter
    end
  end

end
