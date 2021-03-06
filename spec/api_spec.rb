describe MdToBbcode do

  it 'converts and keeps new lines' do
    md = <<~EOS
      Line 1

      Line 2<br>
      Line 3<br><br>
      Line 4<br>
      

      Line 5
      

      Line 6
    EOS
    expect(md.md_to_bbcode).to eq(<<~EOS)
      Line 1
      Line 2

      Line 3


      Line 4

      Line 5
      Line 6
    EOS
  end

  it 'converts heading 1' do
    expect('# Heading 1'.md_to_bbcode).to eq "\n[size=6][b]Heading 1[/b][/size]"
  end

  it 'converts heading 2' do
    expect('## Heading 2'.md_to_bbcode).to eq "\n[size=6]Heading 2[/size]"
  end

  it 'converts heading 3' do
    expect('### Heading 3'.md_to_bbcode).to eq "\n[size=5][b]Heading 3[/b][/size]"
  end

  it 'converts heading 4' do
    expect('#### Heading 4'.md_to_bbcode).to eq "\n[size=5]Heading 4[/size]"
  end

  it 'converts bold text' do
    expect('**Bold text**'.md_to_bbcode).to eq '[b]Bold text[/b]'
  end

  it 'converts italic text' do
    expect('*Italic text*'.md_to_bbcode).to eq '[i]Italic text[/i]'
  end

  it 'converts italic text with underscore' do
    expect('_Italic text_'.md_to_bbcode).to eq '[i]Italic text[/i]'
  end

  it 'converts italic text after a list' do
    md = <<~EOS
      * List item
      *Italic text*
    EOS
    expect(md.md_to_bbcode).to eq(<<~EOS)
      [list]
      [*]List item
        [i]Italic text[/i]
      [/list]
    EOS
  end

  it 'converts italic and bold mixed text' do
    expect('*Italic and **bold** text* and then **bold and *italic* text**'.md_to_bbcode).to eq '[i]Italic and [b]bold[/b] text[/i] and then [b]bold and [i]italic[/i] text[/b]'
  end

  it 'converts links' do
    expect('[Link text](https://my.domain.com/path)'.md_to_bbcode).to eq '[url=https://my.domain.com/path]Link text[/url]'
  end

  it 'converts inline code' do
    expect('`in-line code`'.md_to_bbcode).to eq '[b][font=Courier New]in-line code[/font][/b]'
  end

  it 'converts inline code in bold text' do
    expect('**Bold `in-line code` to display**'.md_to_bbcode).to eq '[b]Bold [font=Courier New]in-line code[/font] to display[/b]'
  end

  it 'converts inline code in multi-line bold text' do
    md = <<~EOS
      `Before in-line` followed by **bold with `some in-line` and
      containing a multi-line `in-line code`
      to display along with `in-line code` again** and `after as-well`.
    EOS
    expect(md.md_to_bbcode).to eq(<<~EOS)
      [b][font=Courier New]Before in-line[/font][/b] followed by [b]bold with [font=Courier New]some in-line[/font] and
      containing a multi-line [font=Courier New]in-line code[/font]
      to display along with [font=Courier New]in-line code[/font] again[/b] and [b][font=Courier New]after as-well[/font][/b].
    EOS
  end

  it 'converts inline code in italic text' do
    expect('*Italic `in-line code` to display*'.md_to_bbcode).to eq '[i]Italic [b][font=Courier New]in-line code[/font][/b] to display[/i]'
  end

  it 'converts inline code in a multi-line bold text' do
    md = <<~EOS
      **Bold
      `in-line code`
      on
      multi-line**
    EOS
    expect(md.md_to_bbcode).to eq(<<~EOS)
      [b]Bold
      [font=Courier New]in-line code[/font]
      on
      multi-line[/b]
    EOS
  end

  it 'converts inline code in a multi-line italic text' do
    md = <<~EOS
      *Italic
      `in-line code`
      on
      multi-line*
    EOS
    expect(md.md_to_bbcode).to eq(<<~EOS)
      [i]Italic
      [b][font=Courier New]in-line code[/font][/b]
      on
      multi-line[/i]
    EOS
  end

  it 'converts bold text in links' do
    expect("This is [a link with **bold** text](http://my.domain.com/path)".md_to_bbcode).to eq 'This is [url=http://my.domain.com/path]a link with [b]bold[/b] text[/url]'
  end

  it 'converts inline code in links' do
    expect('This is [a link with `inline` code](http://my.domain.com/path)'.md_to_bbcode).to eq 'This is [url=http://my.domain.com/path]a link with [b][font=Courier New]inline[/font][/b] code[/url]'
  end

  it 'does not convert other formatting in inline code' do
    expect('`# in-line *code* that is **not formatted**`'.md_to_bbcode).to eq '[b][font=Courier New]# in-line *code* that is **not formatted**[/font][/b]'
  end

  it 'converts images' do
    expect('![Image text](https://my.domain.com/image.jpg)'.md_to_bbcode).to eq '[img]https://my.domain.com/image.jpg[/img]'
  end

  it 'converts bold text on several lines' do
    md = <<~EOS
      **Bold
      text
      on
      multi-line**
    EOS
    expect(md.md_to_bbcode).to eq(<<~EOS)
      [b]Bold
      text
      on
      multi-line[/b]
    EOS
  end

  it 'converts bold text on several lines mixed with single lines' do
    md = <<~EOS
      **Bold text** on **single and
      on
      multi-line** but **with** some **new
      text
      on** other **lines**
      all
      **mixed** up
    EOS
    expect(md.md_to_bbcode).to eq(<<~EOS)
      [b]Bold text[/b] on [b]single and
      on
      multi-line[/b] but [b]with[/b] some [b]new
      text
      on[/b] other [b]lines[/b]
      all
      [b]mixed[/b] up
    EOS
  end

  it 'converts bold and italic texts on several lines mixed with single lines' do
    md = <<~EOS
      **Bold text** on **single and
      *on italic
      words* on
      multi-line** but **with** some **new
      text
      on** other **lines**
      all *italic **and bold**
      **mixed*** up
    EOS
    expect(md.md_to_bbcode).to eq(<<~EOS)
      [b]Bold text[/b] on [b]single and
      [i]on italic
      words[/i] on
      multi-line[/b] but [b]with[/b] some [b]new
      text
      on[/b] other [b]lines[/b]
      all [i]italic [b]and bold[/b]
      [b]mixed[/b][/i] up
    EOS
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

  it 'converts different numbered lists separated with a blank line' do
    md = <<~EOS
      1. List item 11
      2. List item 12
      3. List item 13
      In list item

      Not list

      1. List item 21
      2. List item 22
      3. List item 23
    EOS
    expect(md.md_to_bbcode).to eq(<<~EOS)
      [list=1]
      [*]List item 11
      [*]List item 12
      [*]List item 13
        In list item
      [/list]
      Not list
      [list=1]
      [*]List item 21
      [*]List item 22
      [*]List item 23
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

  it 'converts multi-line numbered list without indent' do
    md = <<~EOS
      1. List item 1
      And another line 1
      Again 1
      2. List item 2
      And another line 2
      Again 2
      3. List item 3
      And another line 3
      Again 3
    EOS
    expect(md.md_to_bbcode).to eq(<<~EOS)
      [list=1]
      [*]List item 1
        And another line 1
        Again 1
      [*]List item 2
        And another line 2
        Again 2
      [*]List item 3
        And another line 3
        Again 3
      [/list]
    EOS
  end

  it 'converts multi-line numbered list with indent' do
    md = <<~EOS
      1. List item 1
        And another line 1
        Again 1
      2. List item 2
        And another line 2
        Again 2
      3. List item 3
        And another line 3
        Again 3
    EOS
    expect(md.md_to_bbcode).to eq(<<~EOS)
      [list=1]
      [*]List item 1
        And another line 1
        Again 1
      [*]List item 2
        And another line 2
        Again 2
      [*]List item 3
        And another line 3
        Again 3
      [/list]
    EOS
  end

  it 'converts multi-line numbered list with empty lines' do
    md = <<~EOS
      1. List item 1
        And another line 1<br>
      2. List item 2
        And another line 2<br>
      3. List item 3
        And another line 3
    EOS
    expect(md.md_to_bbcode).to eq(<<~EOS)
      [list=1]
      [*]List item 1
        And another line 1
      
      [*]List item 2
        And another line 2
      
      [*]List item 3
        And another line 3
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
      [code]def hello
        puts 'Hello world'
      end
      hello
      $stdin.gets
      [/code]
    EOS
  end

  it 'does not convert other items in code blocks' do
    md = <<~EOS
      ```ruby
      # This is not a heading
      def hello
        puts 'Hello **world**'
        puts `hostname`
      end
      # Call function
      hello
      puts '[This is a link](https://google.com)'
      puts <<~EOS2
      * And this
      * is
      * a list!
      EOS2
      $stdin.gets
      ```
    EOS
    expect(md.md_to_bbcode).to eq(<<~EOS)
      [code]# This is not a heading
      def hello
        puts 'Hello **world**'
        puts `hostname`
      end
      # Call function
      hello
      puts '[This is a link](https://google.com)'
      puts <<~EOS2
      * And this
      * is
      * a list!
      EOS2
      $stdin.gets
      [/code]
    EOS
  end

  it 'converts multi-line list with code blocks' do
    md = <<~EOS
      1. List item 1
        ```ruby
        puts 'This is code 1'
        $stdin.gets
        ```
      2. List item 2
        ```ruby
        puts 'This is code 2'
        $stdin.gets
        ```
      3. List item 3
        ```ruby
        puts 'This is code 3'
        $stdin.gets
        ```
    EOS
    expect(md.md_to_bbcode).to eq(<<~EOS)
      [list=1]
      [*]List item 1
        [code]
        puts 'This is code 1'
        $stdin.gets
        [/code]
      [*]List item 2
        [code]
        puts 'This is code 2'
        $stdin.gets
        [/code]
      [*]List item 3
        [code]
        puts 'This is code 3'
        $stdin.gets
        [/code]
      [/list]
    EOS
  end

  it 'converts a whole text mixing markups' do
    md = <<~EOS
      # Heading h1

      Normal text
      And another line<br>
      with a line break

      **Bold text**

      Not bold followed by **bold and followed by** not bold.

      Not bold followed by **bold and
      followed
      by** not bold on multi-lines.

      **Bold text including an italic *[link to Google](https://www.google.com)*.**

      This is a bullet list:

      * Bullet item 1
      * Bullet item 2
      * Bullet item 3

      ## Heading h2

      Here is a link to [Google](https://www.google.com/) in a middle of a line.

      An inline code block `this is code` to be inserted.
      And **another one in bold: `this is *code* that **is preformatted**` but written** in bold.

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

      Here is some Ruby:

      ```ruby
      puts 'Hello' * 3 * 5
      # World
      puts `echo World`
      ```

      This is a numbered list with 1 item:

      1. Numbered item 1

      This is a numbered list multi-line:

      1. Numbered item 1
        Additional content 1
      2. Numbered item 2
        Additional content 2
        
      3. Numbered item 3
        Additional content 3

      Here is an inserted image:
      ![Example of image](https://x-aeon.com/muriel.jpg)

      And ending text
    EOS
    expect(md.md_to_bbcode).to eq(<<~EOS)

      [size=6][b]Heading h1[/b][/size]

      Normal text
      And another line

      with a line break
      [b]Bold text[/b]
      Not bold followed by [b]bold and followed by[/b] not bold.
      Not bold followed by [b]bold and
      followed
      by[/b] not bold on multi-lines.
      [b]Bold text including an italic [i][url=https://www.google.com]link to Google[/url][/i].[/b]
      This is a bullet list:
      [list]
      [*]Bullet item 1
      [*]Bullet item 2
      [*]Bullet item 3
      [/list]

      [size=6]Heading h2[/size]

      Here is a link to [url=https://www.google.com/]Google[/url] in a middle of a line.
      An inline code block [b][font=Courier New]this is code[/font][/b] to be inserted.
      And [b]another one in bold: [font=Courier New]this is *code* that **is preformatted**[/font] but written[/b] in bold.

      [size=5][b]Heading h3[/b][/size]


      [size=5]Heading h4 with [b][font=Courier New]embedded code[/font][/b][/size]

      Here is a code block in json:
      [code]
      {
        "my_json": {
          "is": "super",
          "great": "and",
          "useful": true
        }
      }
      [/code]
      This is a numbered list:
      [list=1]
      [*]Numbered item 1
      [*]Numbered item 2
      [*]Numbered item 3
      [/list]
      Here is some Ruby:
      [code]puts 'Hello' * 3 * 5
      # World
      puts `echo World`
      [/code]
      This is a numbered list with 1 item:
      [list=1]
      [*]Numbered item 1
      [/list]
      This is a numbered list multi-line:
      [list=1]
      [*]Numbered item 1
        Additional content 1
      [*]Numbered item 2
        Additional content 2
      [*]Numbered item 3
        Additional content 3
      [/list]
      Here is an inserted image:
      [img]https://x-aeon.com/muriel.jpg[/img]
      And ending text
    EOS
  end

end
