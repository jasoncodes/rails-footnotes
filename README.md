# Rails 3 Footnotes
#### Version 4.0.0.pre
#### MIT License

## Rails 3

Rails 3 compatibility was started by mperham, but was dropped when he discovered rack-bug. I happen to have a
soft spot for rails-footnotes, so I'm keeping this around for myself.

## Description

If you are developing in Rails you should know the plugin! It displays footnotes in your application for easy
debugging, such as sessions, request parameters, cookies, filter chain, routes, queries, etc.

Even more, it contains links to open files directly in your editor including your backtrace lines.


## Installation

In your Gemfile:

    gem 'rails3-footnotes', :git => 'git://github.com/jasoncodes/rails-footnotes.git'

## Configuration

If you are using MacVim as your editor, add this line to an initializer:

    Footnotes::Filter.prefix = 'mvim://open?url=file://%s&amp;line=%d&amp;column=%d'

If you have another editor, simply create a prefix that will result in a link your editor understands. The %s
is replaced by the name of the file, the first %d is replaced by the line number and the second %d is replaced
by the column.

By default, footnotes are appended at the end of the page with default stylesheet. If you want to change their
position, you can define a div with id "footnotes_holder" or define your own stylesheet by turning footnotes
stylesheet off:

    Footnotes::Filter.no_style = true

Another option is to allow multiple notes to be opened at the same time:

    Footnotes::Filter.multiple_notes = true

If you have New Relic RPM installed, you may want to turn off query explains
(explains can slows things down)

    Footnotes::Notes::QueriesNote.sql_explain = false

Finally, you can control which notes you want to show. The default are:

    Footnotes::Filter.notes = [:controller, :view, :layout, :partials, :stylesheets, :javascripts, :assigns, :queries]


## Creating your own notes

Create your notes to integrate with Footnotes is easy.

  1. Create a Footnotes::Notes::YourExampleNote class

  2. Implement the necessary methods (check abstract_note.rb file in lib/notes)

  3. Append your example note in Footnotes::Filter.notes array (usually at the end of your environment file or in an initializer):

    For example, to create a note that shows info about the user logged in your application you just have to do:

        module Footnotes
          module Notes
            class CurrentUserNote < AbstractNote
              # This method always receives a controller
              #
              def initialize(controller)
                @current_user = controller.instance_variable_get("@current_user")
              end

              # Returns the title that represents this note.
              #
              def title
                "Current user: #{@current_user.name}"
              end

              # This Note is only valid if we actually found an user
              # If it's not valid, it won't be displayed
              #
              def valid?
                @current_user
              end

              # The fieldset content
              #
              def content
                escape(@current_user.inspect)
              end
            end
          end
        end

    Then put in your environment:

        Footnotes::Filter.notes += [:current_user]



#### Version 3.6.7

This plugin was maintained until version 3.6.7 by [Keenan Brock][kb] (keenan@thebrocks.net), along with contributors [Leon Li][ll], [Ivan Storck][is], and [Kris Chamber][kc].

[kb]: http://github.com/kbrock
[ll]: http://github.com/scorpio
[is]: http://github.com/ivanoats
[kc]: http://github.com/kristopher

#### Version 3.6

This plugin was maintained until version 3.6 by [José Valim][jv] (jose@plataformatec.com.br).
Copyright (c) 2009 José Valim.

[jv]: http://blog.plataformatec.com.br/

#### Version 2.0

This plugin was created and maintained until version 2.0 by Duane Johnson. Copyright (c) 2006 [InquiryLabs](http://blog.inquirylabs.com/), Inc.
