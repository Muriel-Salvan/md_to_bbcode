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
    already_in_list = false
    markdown.
      # Images (do this gsub before links and any single tags, like bold, headings...)
      gsub(/!\[(.*?)\]\((.*?)\)/, '[img]\2[/img]').
      # Links
      gsub(/\[(.*?)\]\((.*?)\)/, '[url=\2]\1[/url]').
      # Bold
      gsub(/\*\*(.*?)\*\*/m, '[b]\1[/b]').
      # Heading 1
      gsub(/^# (.*?)$/, '[size=6][b]\1[/b][/size]').
      # Heading 2
      gsub(/^## (.*?)$/, '[size=6]\1[/size]').
      # Heading 3
      gsub(/^### (.*?)$/, '[size=5][b]\1[/b][/size]').
      # Heading 4
      gsub(/^#### (.*?)$/, '[size=5]\1[/size]').
      # Code blocks (do this before in-line code)
      gsub(/```(.*?)\n(.*?)```/m, "[code]\\2[/code]").
      # In-line code
      gsub(/`(.*?)`/, '[b][font=Courier New]\1[/font][/b]').
      # Perform lists transformations
      split("\n").each do |line|
        if line =~ /^\* (.+)$/
          # Single bullet line
          bbcode_lines << '[list]' unless already_in_list
          bbcode_lines << "[*]#{$1}"
          already_in_list = true
        elsif line =~ /^\d\. (.+)$/
          # Single numbered line
          bbcode_lines << '[list=1]' unless already_in_list
          bbcode_lines << "[*]#{$1}"
          already_in_list = true
        else
          if already_in_list && !(line =~ /^  (.*)$/)
            bbcode_lines << '[/list]'
            already_in_list = false
          end
          bbcode_lines << line
        end
      end
    bbcode_lines << '[/list]' if already_in_list
    bbcode_lines << '' if markdown.end_with?("\n")
    bbcode_lines.join("\n")
  end

end

# Add the functionality to the String class
String.include MdToBbcode::CoreExtensions::String::MdToBbcode
