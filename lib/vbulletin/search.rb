module VBulletin
  class Search < Base

    def initialize(api, options = {})
      @api = api
      @debug = options[:debug] || false
    end

    def find_posts_by_user_id(user_id)
      parse_index(@api.construct_full_url("search.php", { 'do' => 'finduser', 'u' => user_id }))
    end

    def find_thread_by_post_id(post_id)
      if (result = @api.mechanize.get(@api.construct_full_url("printthread.php", { 'p' => post_id, 'pp' => 1 })))
        thread_link = result.search('//a[@accesskey="3"]').first
        thread_title = thread_link.content
        thread_id = CGI.parse(URI.parse(thread_link['href']).query)['t'][0]
        thread_author = result.search('//td[@class="page"]/table/tr/td').first
        thread_created_at = result.search('//td[@class="page"]/table/tr/td[@class="smallfont"]').first.to_s
        VBulletin::Thread.new(:id => thread_id, :title => thread_title, :created_at => thread_created_at)
      end
    end

    private
    def parse_index(url)
      if (result = @api.mechanize.get(url))
        if (result = @api.mechanize.get(result.uri.to_s + "&perpage=10"))
          parse_search_results(result)
        end
      end
    end

    def parse_search_results(page)
      posts = []
      page.search('//div[@class="smallfont"]/em/a').each do |link|
        posts << CGI.parse(URI.parse(link['href']).query)['p'][0]
      end

      vb_posts = []

      posts.each do |post_id|
        if (result = @api.mechanize.get(@api.construct_full_url("showpost.php", { 'p' => post_id })))
          post_content = result.search("//div[@id=\"post_message_#{post_id}\"]").first.inner_html.strip
          #post_thread_name =  result.search('//td[@class="tcat"]/div[@class="smallfont"]/a').first.children
          post_author_name = result.search("//div[@id=\"postmenu_#{post_id}\"]/a/span/span").first.content
          post_created_at = result.search('//td[@id="currentPost"]').first.content.strip
          post_author_id = CGI.parse(URI.parse(result.search("//div[@id=\"postmenu_#{post_id}\"]/a").first['href']).query)['u'][0]
          vb_posts << VBulletin::Post.new(@api, :id => post_id, :content => post_content, :author_id => post_author_id, :author_name => post_author_name, :created_at => post_created_at)
        end
      end

      vb_posts
    end

  end
end