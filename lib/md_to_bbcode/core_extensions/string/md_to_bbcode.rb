module MdToBbcode

  module CoreExtensions

    module String

      module MdToBbcode

        # Convert a string representation of self from Markdown to Bbcode
        #
        # Result::
        # * String: BBCode converted text
        def md_to_bbcode
          ::MdToBbcode.md_to_bbcode(self.to_s)
        end

      end

    end

  end

end
