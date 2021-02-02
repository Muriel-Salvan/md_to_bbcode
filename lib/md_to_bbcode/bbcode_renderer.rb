require 'redcarpet/render_strip'

module MdToBbcode

  class BbcodeRenderer < Redcarpet::Render::StripDown

    MARKER_BOLD = '--MdToBbcode--Bold--'
    MARKER_ITALIC = '--MdToBbcode--Italic--'

    def preprocess(doc)
      # Due to Redcarpet bug https://github.com/vmg/redcarpet/issues/396 we have to handle bold and italic conversions before hand
      # Be careful to mark them uniquely so that we don't convert them if they were in a code block
      # TODO: Remove this when Redcarpet bug will be fixed
      doc.
        gsub('**', MARKER_BOLD).
        gsub(/\*(\S|$)/, "#{MARKER_ITALIC}\\1").
        gsub(/(\S)\*/, "\\1#{MARKER_ITALIC}")
    end

    def postprocess(doc)
      # Convert bold and italic correctly due to bug https://github.com/vmg/redcarpet/issues/396
      bbcode_lines = []
      in_bold_text = false
      in_italic_text = false
      # Due to Redcarpet bug https://github.com/vmg/redcarpet/issues/600 we have to change some in-line code to blocks
      # TODO: Remove when Redcarpet will be fixed
      doc.split("\n").map do |line|
        case line
        when /^(\s*)\[b\]\[font=Courier New\]([^\[]*)$/
          "#{$1}[code]"
        when /^(\s*)\[\/font\]\[\/b\]$/
          "#{$1}[/code]"
        else
          # Replace the bold markers with [b] or [/b], and
          # make sure we remove occurences of bold text ([b] and [/b] already part of the text) when bold is already applied: this can happen as we use bold text for inline code
          # TODO: Remove this when https://github.com/vmg/redcarpet/issues/396 will be corrected
          fields = line.split(MARKER_BOLD) + (line.end_with?(MARKER_BOLD) ? [''] : [])
          line = fields.map.with_index do |field, idx|
            content = in_bold_text ? field.gsub('[b]', '').gsub('[/b]', '') : field
            if idx == fields.size - 1
              content
            else
              in_bold_text = !in_bold_text
              "#{content}[#{in_bold_text ? '' : '/'}b]"
            end
          end.join
          # Italic
          if in_italic_text
            line.gsub!(/#{Regexp.escape(MARKER_ITALIC)}(\S.*?)#{Regexp.escape(MARKER_ITALIC)}/, '[/i]\1[i]')
          else
            line.gsub!(/#{Regexp.escape(MARKER_ITALIC)}(\S.*?)#{Regexp.escape(MARKER_ITALIC)}/, '[i]\1[/i]')
          end
          if in_italic_text && line =~ /.*\S#{Regexp.escape(MARKER_ITALIC)}.*/
            line.gsub!(/(.*\S)#{Regexp.escape(MARKER_ITALIC)}(.*)/, '\1[/i]\2')
            in_italic_text = false
          elsif !in_italic_text && line =~ /.*#{Regexp.escape(MARKER_ITALIC)}\S.*/
            line.gsub!(/(.*)#{Regexp.escape(MARKER_ITALIC)}(\S.*)/, '\1[i]\2')
            in_italic_text = true
          end
          line
        end
      end.join("\n").gsub('<br>', "\n")
    end

    def emphasis(text)
      "[i]#{text}[/i]"
    end

    def double_emphasis(text)
      # In case the text already contains bold tags (which can be the case as codespan uses them), remove them.
      "[b]#{text.gsub('[b]', '').gsub('[/b]', '')}[/b]"
    end

    def link(link, title, content)
      "[url=#{link}]#{content}[/url]"
    end

    def header(text, header_level)
      case header_level
      when 1
        "\n[size=6][b]#{text}[/b][/size]\n\n"
      when 2
        "\n[size=6]#{text}[/size]\n\n"
      when 3
        "\n[size=5][b]#{text}[/b][/size]\n\n"
      when 4
        "\n[size=5]#{text}[/size]\n\n"
      else
        "\n[size=4][b]#{text}[/b][/size]\n\n"
      end
    end

    def codespan(code)
      "[b][font=Courier New]#{code.
        gsub(MARKER_BOLD, '**').
        gsub(MARKER_ITALIC, '*')
      }[/font][/b]"
    end

    def image(link, title, alt_text)
      "[img]#{link}[/img]"
    end

    def list(contents, list_type)
      case list_type
      when :ordered
        "[list=1]\n#{contents}[/list]\n"
      else
        "[list]\n#{contents}[/list]\n"
      end
    end

    def list_item(text, list_type)
      # If the item spans multiple lines, prefix each new line with 2 spaces to keep the list running.
      "[*]#{text.split(/(?<=\n)/).join("  ")}"
    end

    def block_code(code, language)
      "[code]#{code.
        gsub(MARKER_BOLD, '**').
        gsub(MARKER_ITALIC, '*')
      }[/code]\n"
    end

  end

end
