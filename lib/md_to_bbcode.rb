require 'md_to_bbcode/core_extensions/string/md_to_bbcode'

module MdToBbcode

  # Convert a Markdown string to Bbcode
  #
  # Parameters::
  # * *markdown* (String): The Markdown string
  # Result::
  # * String: BBCode converted string
  def self.md_to_bbcode(markdown)
    bbcode_lines = []
    in_a_list = false
    in_a_code_block = false
    in_bold_text = false
    in_italic_text = false
    markdown.split("\n").each do |line|
      unindented_line = in_a_list && line =~ /^  (.*)$/ ? $1 : line
      if unindented_line =~ /^```(.*)$/
        if in_a_code_block
          # We exit a code block
          bbcode_lines << "#{in_a_list ? '  ' : ''}[/code]\n"
          in_a_code_block = false
        else
          # We enter a code block
          bbcode_lines << "#{in_a_list ? '  ' : ''}[code]"
          in_a_code_block = true
        end
      elsif in_a_code_block
        # Don't change anything at the formatting
        bbcode_lines << "#{line}\n"
      else
        # Handle in-line code markers first
        line = line.split(/(`.+?`)/).map do |field|
          if field[0] == '`'
            # Don't change anything at the formatting
            "#{in_bold_text ? '' : '[b]'}[font=Courier New]#{field[1..-2]}[/font]#{in_bold_text ? '' : '[/b]'}"
          else
            # Apply the formatting except the formatting used for whole lines (headers, bullets, lists...)
            # Images (do this gsub before links and any single tags, like bold, headings...)
            field.gsub!(/!\[(.*?)\]\((.*?)\)/, '[img]\2[/img]')
            # Links
            field.gsub!(/\[(.*?)\]\((.*?)\)/, '[url=\2]\1[/url]')
            # Bold (do this before italic)
            if in_bold_text
              field.gsub!(/\*\*(.*?)\*\*/, '[/b]\1[b]')
            else
              field.gsub!(/\*\*(.*?)\*\*/, '[b]\1[/b]')
            end
            if field =~ /.*\*\*.*/
              if in_bold_text
                field.gsub!(/(.*)\*\*(.*)/, '\1[/b]\2')
                in_bold_text = false
              else
                field.gsub!(/(.*)\*\*(.*)/, '\1[b]\2')
                in_bold_text = true
              end
            end
            # Italic
            if in_italic_text
              field.gsub!(/\*(\S.*?)\*/, '[/i]\1[i]')
            else
              field.gsub!(/\*(\S.*?)\*/, '[i]\1[/i]')
            end
            if field =~ /.*\*.*/
              if in_italic_text
                field.gsub!(/(.*\S)\*(.*)/, '\1[/i]\2')
                in_italic_text = false
              else
                field.gsub!(/(.*)\*(\S.*)/, '\1[i]\2')
                in_italic_text = true
              end
            end
            field
          end
        end.join
        # Heading 1
        line.gsub!(/^# (.*?)$/, '[size=6][b]\1[/b][/size]')
        # Heading 2
        line.gsub!(/^## (.*?)$/, '[size=6]\1[/size]')
        # Heading 3
        line.gsub!(/^### (.*?)$/, '[size=5][b]\1[/b][/size]')
        # Heading 4
        line.gsub!(/^#### (.*?)$/, '[size=5]\1[/size]')
        # Bullets
        if line =~ /^\* (.+)$/
          # Single bullet line
          bbcode_lines << "[list]\n" unless in_a_list
          bbcode_lines << "[*]#{$1}\n"
          in_a_list = true
        elsif line =~ /^\d\. (.+)$/
          # Single numbered line
          bbcode_lines << "[list=1]\n" unless in_a_list
          bbcode_lines << "[*]#{$1}\n"
          in_a_list = true
        else
          if in_a_list && !(line =~ /^  (.*)$/)
            bbcode_lines << "[/list]\n"
            in_a_list = false
          end
          bbcode_lines << "#{line}\n"
        end
      end
    end
    bbcode_lines << "[/list]\n" if in_a_list
    bbcode = bbcode_lines.join
    markdown.end_with?("\n") ? bbcode : bbcode[0..-2]
  end

end

# Add the functionality to the String class
String.include MdToBbcode::CoreExtensions::String::MdToBbcode
