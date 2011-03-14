require "#{File.dirname(__FILE__)}/abstract_note"

module Footnotes
  module Notes
    class LayoutNote < AbstractNote
      def initialize(controller)
        @controller = controller
      end

      ActiveSupport::Notifications.subscribe("render_template.action_view") do |name, start, finish, id, payload|
        class_variable_set :@@layout_path, payload[:layout]
      end

      def row
        :edit
      end

      def link
        escape(Footnotes::Filter.prefix(filename, 1, 1))
      end

      def valid?
        !!@@layout_path
      end

      protected
        def filename
          @@layout_path && @controller.find_template(@@layout_path).identifier
        end
    end
  end
end
