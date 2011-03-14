require "#{File.dirname(__FILE__)}/abstract_note"

module Footnotes
  module Notes
    class PartialsNote < AbstractNote
      attr_reader :partials

      def initialize(controller)
        @controller = controller
        @partials = self.class.partials.dup
        self.class.partials.clear
      end

      notification_proc = lambda { |name, start, finish, id, payload|
        key = payload[:identifier]
        partials[key] ||= { :time => 0, :count => 0}
        partials[key][:time] += finish - start
        partials[key][:count] += payload[:count] || 1
      }
      %w(render_partial.action_view render_collection.action_view).each do |name|
        ActiveSupport::Notifications.subscribe name, notification_proc
      end

      def row
        :edit
      end

      def title
        "Partials (#{partials.size})"
      end

      def content
        rows = partials.map do |filename, data|
          href = Footnotes::Filter.prefix(filename,1,1)
          shortened_name=filename.gsub(File.join(Rails.root,"app/views/"),"")
          [
            %{<a href="#{href}">#{shortened_name}</a>},
            "#{@controller.view_context.number_with_precision data[:time]*1000, :precision => 1, :delimiter => ','}ms",
            @controller.view_context.number_with_delimiter(data[:count])
          ]
        end
        mount_table(rows.unshift(%w(Partial Time Count)), :summary => title)
      end

      def stylesheet
        """
        #partials_debug_info table tr :not(:first-child) {
          text-align: right;
        }
        """
      end

      protected

      def self.partials
        @partials ||= {}
      end
    end
  end
end
