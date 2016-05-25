require 'nokogiri'
require 'open-uri'

URL = "http://www.oantagonista.com/"

class Pagina
    attr_reader :html

    def initialize(pagina = 1)
        begin
            @page = Nokogiri::HTML(open(URL + "/pagina/#{pagina}").read, nil, "UTF-8")
            @html = []

            artigos = @page.xpath("//article")
            artigos.each do |article|
                data = {}
                data[:path]      = article.css("a")[0]['href']
                data[:full_path] = URL + data[:path]
                data[:title]     = article.css('h3').text
                data[:date]      = article.css('span.post-meta').text

                @html << data
            end

        rescue OpenURI::HTTPError => httpe
            puts "HTTPError..."
            @html = ""
            return
        end
    end

end


class Noticia
    attr_reader :html

    def initialize(path)
        begin
            page = Nokogiri::HTML(open(URL + path).read, nil, "UTF-8")
            p_tags = page.xpath("//div[@class='l-main-right']/p") # carrega o conteúdo da notícia
            p_tags.pop if p_tags.last.children.first.name == 'br' # remove último <p> se for <br>
            @html = p_tags.to_s
        rescue OpenURI::HTTPError => httpe
            puts "HTTPError..."
            @html = ""
            return
        end
    end
end
