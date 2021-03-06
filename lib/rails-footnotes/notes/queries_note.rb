require "#{File.dirname(__FILE__)}/abstract_note"

module Footnotes
  module Notes
    class QueriesNote < AbstractNote
      @@alert_db_time = 0.16
      @@alert_sql_number = 8
      @@sql = []
      
      cattr_accessor :sql, :alert_db_time, :alert_sql_number, :alert_explain, :loaded, :sql_explain, :instance_writter => false
      
      def initialize(controller)
        @controller = controller
      end

      ActiveSupport::Notifications.subscribe("sql.active_record") do |name, start, finish, id, payload|
        if payload[:sql] =~ /^(select|create|update|delete)\b/i
          type = $&.downcase.to_sym
          explain = nil

          if type == :select && Footnotes::Notes::QueriesNote.sql_explain
            log_silence do
              explain = ActiveRecord::Base.connection.execute("EXPLAIN #{query}", name)
            end
          end

          Footnotes::Notes::QueriesNote.sql << Footnotes::Notes::QueriesNote::Sql.new(type, payload[:name], finish-start, payload[:sql], explain)
        end
      end
      
      def self.start!(controller)
        @@sql = []
      end

      def self.to_sym
        :queries
      end

      def title
        db_time = @@sql.inject(0){|sum, item| sum += item.time }
        query_color = generate_red_color(@@sql.length, alert_sql_number)
        db_color    = generate_red_color(db_time, alert_db_time)

        <<-TITLE
  <span style="background-color:#{query_color}">Queries (#{@@sql.length})</span> 
  <span style="background-color:#{db_color}">DB (#{@controller.view_context.number_with_precision db_time*1000, :precision => 1, :delimiter => ','}ms)</span>
        TITLE
      end

      def stylesheet
        <<-STYLESHEET
  #queries_debug_info table td, #queries_debug_info table th{border:1px solid #A00; padding:0 3px; text-align:center;}
  #queries_debug_info table thead, #queries_debug_info table tbody {color:#A00;}
  #queries_debug_info p {background-color:#F3F3FF; border:1px solid #CCC; margin:12px; padding:4px 6px;}
  #queries_debug_info a:hover {text-decoration:underline;}
        STYLESHEET
      end

      def content
        html = ''

        @@sql.each_with_index do |item, i|
          sql_links = []
          sql_links << "<a href=\"javascript:Footnotes.toggle('qtable_#{i}')\" style=\"color:#A00;\">explain</a>" if item.explain
          sql_links << "<a href=\"javascript:Footnotes.toggle('qtrace_#{i}')\" style=\"color:#00A;\">trace</a>" if item.trace

          html << <<-HTML
  <b id="qtitle_#{i}">#{escape(item.type.to_s.upcase)}</b> (#{sql_links.join(' | ')})<br />
  #{print_name_and_time(item.name, item.time)}<br />
  <span id="explain_#{i}">#{print_query(item.query)}</span><br />
  #{print_explain(i, item.explain) if item.explain}
  <p id="qtrace_#{i}" style="display:none;">#{parse_trace(item.trace) if item.trace}</p><br />
          HTML
        end

        return html
      end
      
      def self.load
        ActiveRecord::ConnectionAdapters::AbstractAdapter.send :include, Footnotes::Extensions::AbstractAdapter
      end
      
      protected
        def parse_explain(results)
          table = []
          table << results.fetch_fields.map(&:name)
          results.each do |row|
            table << row
          end
          table
        end

        def parse_trace(trace)
          trace.map do |t|
            s = t.split(':')
            %[<a href="#{escape(Footnotes::Filter.prefix("#{Rails.root.to_s}/#{s[0]}", s[1].to_i, 1))}">#{escape(t)}</a><br />]
          end.join
        end

        def print_name_and_time(name, time)
          "<span style='background-color:#{generate_red_color(time, alert_ratio)}'>#{escape(name || 'SQL')} (#{@controller.view_context.number_with_precision time*1000, :precision => 1, :delimiter => ','}ms)</span>"
        end

        def print_query(query)
          escape(query.to_s.gsub(/(\s)+/, ' ').gsub('`', ''))
        end

        def print_explain(i, explain)
          mount_table(parse_explain(explain), :id => "qtable_#{i}", :style => 'margin:10px;display:none;', :summary => "Debug information for #{title}")
        end

        def generate_red_color(value, alert)
          c = ((value.to_f/alert).to_i - 1) * 16
          c = 0  if c < 0
          c = 15 if c > 15

          c = (15-c).to_s(16)
          "#ff#{c*4}"
        end

        def alert_ratio
          alert_db_time / alert_sql_number
        end

      class Sql
        attr_accessor :type, :name, :time, :query, :explain, :trace

        def initialize(type, name, time, query, explain)
          @type = type
          @name = name
          @time = time
          @query = query
          @explain = explain

          @trace = Kernel.caller.collect(&:strip).select do |line|
            # select source files which are within the app directory
            line.gsub!(/^#{Regexp.escape Rails.root.to_s}\//im, '')
          end.map do |line|
            # strip automatically generated Haml method name
            line.gsub(/(.haml:\d+):in .*$/, '\1')
          end
        end
      end

    end
  end
  
  module Extensions
    module AbstractAdapter
      def log_silence
        result = nil
        if @logger
          @logger.silence do
            result = yield
          end
        else
          result = yield
        end
        result
      end
    end

  end
end

Footnotes::Notes::QueriesNote.load
