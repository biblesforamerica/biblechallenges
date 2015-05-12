class Chapter < ActiveRecord::Base

  # Relations
  has_many :chapter_challenges
  has_many :challenges, through: :chapter_challenges
  has_many :verses, primary_key: :chapter_index, foreign_key: :chapter_index  # needs to be ordered by verse_number #todo

  def book_and_chapter
    book_name + " " + chapter_number.to_s
  end


  # Class methods
  def self.search(comma_separated_queries)

    matches = Parser.separate_queries(comma_separated_queries).inject([]) do |results, query|

      fragment, chapters = Parser.parse_query(query)

      # First search by fragment
      bookfrag = Bookfrag.where("upper(:query) like upper(fragment) || '%'",
                                query: fragment).first
      matches = where(book_id: bookfrag.try(:book_id))
      .where(chapter_number: chapters)

      # If nothing found, then search by Chapter name
      unless matches.length > 0 # Using .any? here causes an extra query
        matches = where("upper(book_name) like upper(:query)", query: "#{fragment}")
        .where(chapter_number: chapters)
      end

      results << matches
    end

  end

end
