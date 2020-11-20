require 'md_to_bbcode/core_extensions/string/md_to_bbcode'

module MdToBbcode

  # Convert a Markdown string to Bbcode
  #
  # Parameters::
  # * *markdown* (String): The Markdown string
  # Result::
  # * String: BBCode converted string
  def self.md_to_bbcode(markdown)
    markdown
  end

end

# Add the functionality to the String class
String.include MdToBbcode::CoreExtensions::String::MdToBbcode
