class UrlParser
  def initialize(url)
    @url = url
  end

  def scheme
    @url.split('://').first
  end

  def domain
    @url.split('/').at(2).split(':').first
  end

  def port
    start = false
    port = ''
    i = 0
    @url.each_char do |char|
      port << char if start
      start = true if char == ':' and @url[i + 1] != '/'
      start = false if @url[i+1] == '/'
      i += 1
    end
    port != '' ? port : self.scheme == 'http' ? '80' : '443'
  end

  def path
    start = false
    path = ''
    i = 0
    @url.each_char do |char|
      path << char if start
      start = true if char == '/' and @url[i + 1] != '/' and @url[i-1] != '/'
      start = false if @url[i+1] == '?'
      i += 1
    end
    path != '' ? path : nil
  end

  def query_string
    start = false
    query = ''
    i = 0
    @url.each_char do |char|
      query << char if start
      start = true if char == '?'
      start = false if @url[i+1] == '#'
      i += 1
    end
    hash = query.split('&')
    query_string = Hash.new()
    for string in hash
      temp = string.split('=')
      query_string[temp[0]] = temp[1]
    end
    query_string
  end

  def fragment_id
    start = false
    id = ''
    @url.each_char do |char|
      id << char if start
      start = true if char == '#'
    end
    id
  end
end
