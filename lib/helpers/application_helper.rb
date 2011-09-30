module ApplicationHelper

  # Truncates input string (to number of words specified, using word
  # boundaries) and returns resulting string.
  def truncate_words(text, length = 30, end_string = ' ...')
    if text.nil?
      return ''
    else
      words = text.split()
      return words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
    end
  end
end