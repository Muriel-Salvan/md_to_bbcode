require 'redcarpet'
require 'md_to_bbcode/bbcode_renderer'
require 'md_to_bbcode/core_extensions/string/md_to_bbcode'

module MdToBbcode

  # Convert a Markdown string to Bbcode
  #
  # Parameters::
  # * *markdown* (String): The Markdown string
  # Result::
  # * String: BBCode converted string
  def self.md_to_bbcode(markdown)
    bbcode = Redcarpet::Markdown.new(
      BbcodeRenderer,
      fenced_code_blocks: true,
      lax_spacing: false
    ).render(markdown)
    if markdown.end_with?("\n")
      # Sometimes redcarpet removes new lines (after lists), so add them back if needed
      bbcode.end_with?("\n") ? bbcode : "#{bbcode}\n"
    else
      # Sometimes redcarpet adds new lines (after bold markers), so strip them if needed
      bbcode.end_with?("\n") ? bbcode.strip : bbcode
    end
  end

end

# Add the functionality to the String class
String.include MdToBbcode::CoreExtensions::String::MdToBbcode
