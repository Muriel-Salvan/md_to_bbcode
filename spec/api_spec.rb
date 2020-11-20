describe MdToBbcode do

  it 'converts heading 1' do
    expect('# Heading 1'.md_to_bbcode).to eq '[size=6]Heading 1[/size]'
  end

  it 'converts heading 2' do
    expect('## Heading 2'.md_to_bbcode).to eq '[size=5]Heading 2[/size]'
  end

  it 'converts heading 3' do
    expect('### Heading 3'.md_to_bbcode).to eq '[size=4]Heading 3[/size]'
  end

  it 'converts heading 4' do
    expect('#### Heading 4'.md_to_bbcode).to eq '[size=3]Heading 4[/size]'
  end

  it 'converts bold text' do
    expect('**Bold text**'.md_to_bbcode).to eq '[b]Bold text[/b]'
  end

  it 'converts urls' do
    expect('[Link text](https://my.domain.com/path)'.md_to_bbcode).to eq '[url=https://my.domain.com/path]Link text[/url]'
  end

  it 'converts inline code' do
    expect('`in-line code`'.md_to_bbcode).to eq '[b][font=Courier New]in-line code[/font][/b]'
  end

  it 'converts images' do
    expect('![Image text](https://my.domain.com/image.jpg)'.md_to_bbcode).to eq '[img]https://my.domain.com/image.jpg[/img]'
  end

  it 'converts bullets list' do
    md = <<~EOS
      * List item 1
      * List item 2
      * List item 3
    EOS
    expect(md.md_to_bbcode).to eq(<<~EOS)
      [list]
      [*]List item 1
      [*]List item 2
      [*]List item 3
      [/list]
    EOS
  end

  it 'converts numbered list' do
    md = <<~EOS
      1. List item 1
      2. List item 2
      3. List item 3
    EOS
    expect(md.md_to_bbcode).to eq(<<~EOS)
      [list=1]
      [*]List item 1
      [*]List item 2
      [*]List item 3
      [/list]
    EOS
  end

  it 'converts code blocks' do
    md = <<~EOS
      ```ruby
      def hello
        puts 'Hello world'
      end
      hello
      $stdin.gets
      ```
    EOS
    expect(md.md_to_bbcode).to eq(<<~EOS)
      [code]
      def hello
        puts 'Hello world'
      end
      hello
      $stdin.gets
      [/code]
    EOS
  end

  it 'converts a whole text mixing markups' do
    md = <<~EOS
      # Heading h1

      Normal text

      **Bold text**

      Not bold followed by **bold and followed by** not bold.

      This is a bullet list:
      * Bullet item 1
      * Bullet item 2
      * Bullet item 3

      ## Heading h2

      Here is a link to [Google](https://www.google.com/) in a middle of a line.

      An inline code block `this is code` to be inserted.

      ### Heading h3

      #### Heading h4 with `embedded code`

      Here is a code block in json:
      ```json
      {
        "my_json": {
          "is": "super",
          "great": "and",
          "useful": true
        }
      }
      ```

      This is a numbered list:
      1. Numbered item 1
      2. Numbered item 2
      3. Numbered item 3

      Here is an inserted image:
      ![Example of image](https://x-aeon.com/muriel.jpg)

      And ending text
    EOS
    expect(md.md_to_bbcode).to eq(<<~EOS)
    EOS
  end

end
