# frozen_string_literal: true

require "test_helper"

class StringTagTest < Minitest::Test
  def test_normalize_yard_value_with_simple_string
    input = '"Simple string"'
    expected = "Simple string"
    assert_equal expected, ReadmeYard::StringTag.normalize_yard_value(input)
  end

  def test_normalize_yard_value_with_line_continuation
    input = '"This is a string " \
"with line continuation"'
    expected = "This is a string with line continuation"
    assert_equal expected, ReadmeYard::StringTag.normalize_yard_value(input)
  end

  def test_normalize_yard_value_with_multiple_lines
    input = '"First line " \
"second line " \
"third line"'
    expected = "First line second line third line"
    assert_equal expected, ReadmeYard::StringTag.normalize_yard_value(input)
  end

  def test_normalize_yard_value_with_escape_characters
    input = '"String with escape sequences: \n \t \\"quotes\\""'
    expected = "String with escape sequences: \n \t \"quotes\""
    assert_equal expected, ReadmeYard::StringTag.normalize_yard_value(input)
  end

  def test_normalize_yard_value_with_xzample_one
    input = '"I heard you like self-documenting Ruby, so I wrote " \
"self-documenting Ruby for your self-documenting Ruby."'
    expected = "I heard you like self-documenting Ruby, so I wrote self-documenting Ruby for your self-documenting Ruby."
    assert_equal expected, ReadmeYard::StringTag.normalize_yard_value(input)
  end

  def test_normalize_yard_value_with_xzample_two
    input = "I heard you like self-documenting Ruby, so I wrote " \
            "self-documenting Ruby for your self-documenting Ruby."
    expected = "I heard you like self-documenting Ruby, so I wrote self-documenting Ruby for your self-documenting Ruby."
    assert_equal expected, ReadmeYard::StringTag.normalize_yard_value(input)
  end

  def test_normalize_yard_value_with_nil_input
    assert_equal "", ReadmeYard::StringTag.normalize_yard_value(nil)
  end

  def test_normalize_yard_value_with_empty_string
    assert_equal "", ReadmeYard::StringTag.normalize_yard_value('""')
  end

  def test_normalize_yard_value_with_different_continuation_format
    input = '"Line one"\
            " line two"'
    expected = "Line one\" line two"
    assert_equal expected, ReadmeYard::StringTag.normalize_yard_value(input)
  end

  def test_normalize_yard_value_with_mixed_escape_sequences
    input = '"String with \\n newline \\t tab and \\\"quotes\\\" and \\\'single quotes\\\'"'
    expected = "String with \n newline \t tab and \\\"quotes\\\" and 'single quotes'"
    assert_equal expected, ReadmeYard::StringTag.normalize_yard_value(input)
  end

  def test_normalize_yard_value_with_heredoc
    input = '<<~TEXT
      This is a heredoc string.
      It preserves line breaks and spacing.
    TEXT'
    expected = "This is a heredoc string.\nIt preserves line breaks and spacing."
    assert_equal expected, ReadmeYard::StringTag.normalize_yard_value(input)
  end

  def test_normalize_yard_value_with_indented_heredoc
    input = '<<~TEXT
              This line has extra indentation.
            This line has standard indentation.
          This line has less indentation.
    TEXT'
    expected = "This line has extra indentation.\nThis line has standard indentation.\nThis line has less indentation."
    assert_equal expected, ReadmeYard::StringTag.normalize_yard_value(input)
  end

  def test_normalize_yard_value_with_different_heredoc_delimiter
    input = '<<~CUSTOM_DELIMITER
      Using a different delimiter.
      Still works the same.
    CUSTOM_DELIMITER'
    expected = "Using a different delimiter.\nStill works the same."
    assert_equal expected, ReadmeYard::StringTag.normalize_yard_value(input)
  end

  def test_normalize_yard_value_with_single_quotes
    input = "'This is a string with single quotes'"
    expected = "This is a string with single quotes"
    assert_equal expected, ReadmeYard::StringTag.normalize_yard_value(input)
  end
end
