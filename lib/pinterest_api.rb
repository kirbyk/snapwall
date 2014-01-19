class PinterestApi
  # Constructor
  #
  # username - String  
  # password - String
  def initialize(email, password)
    @email = email
    @password = password

    @agent = Mechanize.new
    @agent.user_agent_alias = 'iPhone'

    @agent.get "https://pinterest.com"
    @csrftoken = get_csrftoken
  end

  # Public: Login to pinterest with authenticate information
  # This function should be called after initialize
  # 
  # Example
  #   bot = PinterestBot(email, password)
  #   bot.login
  # 
  # Raise exception if login failed       
  def login
    login_path = "https://www.pinterest.com/login"

    @agent.get login_path

    params = {
      "email" => @email,
      "csrftoken" => @csrftoken,
      "csrfmiddlewaretoken" => @csrftoken,
      "password" => @password
    }


    headers  = {
      "X-CSRFToken" => @csrftoken,
      "X-CLASSIC-APP" => 1,
    }


    # used to have more, this is overkill now...
    extra_cookies = {}
    extra_cookies["csrftoken"] = @csrftoken
    proto_cookie = @agent.cookies.last
    extra_cookies.each do |name, value|
      proto_cookie.name = name
      proto_cookie.value = value
      @agent.cookies << proto_cookie
    end


    resp = @agent.post(login_path, 
           params,
           headers)

    if resp.body.match(/isLoggedIn(.*)/).to_s.match(/false/)
      raise "Login failed" 
    end  
  rescue Exception => e
    STDERR.puts e.to_s
    STDERR.puts e.backtrace
  end

  def pin url, board_id, details = "FUCK IT SHIP IT"
    body = {
      "csrfmiddlewaretoken" => @csrftoken,
      "media_url" => url,
      "board" => board_id,
      "img_url" => url,
      "link" => url,
      "details" => details
    }

    resp = @agent.post "/pin/create", body
    resp.code == "200"
  rescue Exception => e
    STDERR.puts e.to_s
    STDERR.puts e.backtrace
  end


  # Public: Get username of this user
  #
  # Return a String    
  def username 
    return @username if @username
    
    res = @agent.get "https://pinterest.com/me/"
    prof_link = res.links.detect do |link|
      link.text == "Profile"
    end
    @username = prof_link.uri.to_s.match(/\/(\w+)\//)[1]
  rescue Exception => e
    STDERR.puts e.to_s
    STDERR.puts e.backtrace
  end


  # Public: Get list of board of this account
  # 
  # Return a Dictionary which 
  #   key - String board name
  #   value - string board_id
  def boards
    return @boards if @boards
    
    @boards = {}
    res = @agent.get "http://pinterest.com/#{username}/"

    i_care = false
    res.links.each do |link|
      if i_care
        name = link.uri.to_s.match(/\/(\w+)\//)[1]
        id = get_board_id name
        @boards[name] = id
      elsif link.uri.to_s == "/#{username}/following/"
        i_care = true
      end
    end
    @boards
  end
  
  def get_board_id name
    link = "/#{name}"
    page = @agent.get link
    id = page.body.match(/(\d{18})/)[0]
    id
  rescue Exception => e
    STDERR.puts e.to_s
    STDERR.puts e.backtrace
  end

  ##### OLD UNTESTED
  # These functions are from github, I mildy updated some so they could work,
  # probably won't though
  #


  # Public: Create new board
  #
  # name - String name of new board
  #   
  # Return a Dictionary object which contains
  #   url - String ULR of new category
  #   status - String :success is expected
  #   name - String `category_name`
  #   id - String ID of new category
  def create_new_board(name)
    headers = {
      "X-CSRFToken" => @csrftoken,
      "X-Pinterest-Referrer" => "http://pinterest.com/",
      "X-Requested-With" => "XMLHttpRequest",
    }
    body = {
      :name => name,
      :pass_category => true,
    }  
    res = @agent.post "https://pinterest.com/board/create/", body, headers
    JSON.parse res.body
  end
 
  private 

  # Mine again, tested, working, being used
  def get_csrftoken
    tok = @agent.cookie_jar.detect { |cookie| cookie.name == "csrftoken" }
    @csrftoken = tok.value
  end
end
