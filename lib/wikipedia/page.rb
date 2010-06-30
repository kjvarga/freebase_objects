require 'hpricot'

class Wikipedia
  class Page; end
  class << Page
    def from_id(wiki_id)
      page = {}
      doc = Hpricot(open("http://en.wikipedia.org/wiki/index.html?curid=#{wiki_id}&printable=yes"))
      return {} if doc.at('h1.firstHeading').inner_text == "Bad title"
      doc = doc.at('#content')
      doc[:id] = ''
      doc.search('script').remove
      doc.search('//a[@href^="/"]').each do |link|
        link[:href] = "http://en.wikipedia.org"+link[:href]
      end
      
      #find abstract (text between first and second table)
      sidebar = doc.at('table.infobox.vcard')
      page[:sidebar] = sidebar.to_html rescue nil
      toc = doc.at('table#toc')
      page[:toc] = toc.to_html rescue nil
      begin
        #find abstract (between sidebar & toc)
        abstract = Hpricot::Elements.expand(sidebar.next_sibling, toc.previous_sibling)
        abstract.search("sup").remove # remove all sup (reference) links from abstract
        page[:abstract] = abstract.to_html
      rescue NoMethodError
      end
      page[:categories] = doc.at('#catlinks')
      page[:title] = doc.at('h1.firstHeading').to_html
      categories = doc.at('#catlinks')
      page[:categories] = categories.to_html
      
      begin
        #remove unusable content from doc
        Hpricot::Elements.expand(sidebar.parent.children[0], sidebar).remove
        abstract.remove
      rescue NoMethodError
      end
      Hpricot::Elements.expand(categories, categories.parent.children[-1]).remove
      
      page[:content] = doc.to_html
      
      page
    end
  end
end