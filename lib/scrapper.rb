class Scrapper
    URL = 'https://www.musical-u.com/learn/exploring-common-chord-progressions/'

    def self.scrape_main_page()
        doc = Nokogiri::HTML(open(URL))
        foo = doc.css("h3 span.cn")
        chord_progressions = foo.collect {|prog| prog.text.split(/[ –-]+/)}.uniq! 
    end
end