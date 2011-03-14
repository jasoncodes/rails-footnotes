require "#{File.dirname(__FILE__)}/abstract_note"

module Footnotes
  module Notes
    class ViewNote < AbstractNote
      def initialize(controller)
        @controller = controller
      end

      ActiveSupport::Notifications.subscribe("render_template.action_view") do |name, start, finish, id, payload|
        class_variable_set :@@view_path, payload[:identifier]
      end

      def row
        :edit
      end

      def link
        escape(Footnotes::Filter.prefix(filename, 1, 1))
      end

      def valid?
        !!@@view_path
      end

    protected

      def filename
        @@view_path
      end

    end
  end
end
