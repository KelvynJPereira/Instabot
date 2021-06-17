# Scraping data on the shipping website
require "selenium-webdriver"
require 'net/http'
require 'uri'
require 'json'
require 'byebug'

# Credentials for login
USER = 'your user'
PASSWORD = 'your password'
# URL instagram
SITE_URL = 'https://www.instagram.com/'
# User profile
INSTAGRAM_PROFILE = 'user who wants to scratch'

# Browser config
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--ignore-certificate-errors')
options.add_argument('--disable-popup-blocking')
options.add_argument('--disable-translate')
options.add_argument('--disable-dev-shm-usage')
options.add_argument('--no-sandbox')
options.add_argument('--headless')
options.add_argument("--window-size=1920,1080")
options.add_argument("--disable-gpu")
options.add_argument("user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36")

# Proxy to not block requests
proxy = Selenium::WebDriver::Proxy.new(http: 'Enter a domestic proxy')
cap   = Selenium::WebDriver::Remote::Capabilities.chrome(proxy: proxy)

# Create browser instance
driver = Selenium::WebDriver.for :chrome, options: options, desired_capabilities: cap

# Consult the page
driver.navigate.to "#{SITE_URL}"

# Waiting for js elements to load
sleep(5)

# Log in with provided credentials
driver.find_element(:name, 'username').send_keys(USER)
driver.find_element(:name, 'password').send_keys(PASSWORD)
driver.find_element(:xpath, '//*[@id="loginForm"]/div/div[3]/button/div').click
# Waiting for JS elements to load
sleep(7)
# Capture all cookies and add in instance
driver.manage.all_cookies.each do |cookie|
  begin
    driver.manage.add_cookie(name: item[:key], value: item[:value])
  ensure
    next
  end
end

# Access desired profile
driver.navigate.to "#{SITE_URL}#{INSTAGRAM_PROFILE}"

# Capture the posts
instagram_feed = []
for row in 1..2
  for column in 1..3    
    post = driver.find_element(:xpath, "//*[@id='react-root']/section/main/div/div[3]/article/div[1]/div/div[#{row}]/div[#{column}]/a").attribute "href"
    instagram_feed.push({shortcode: post.split("p/").last.split("/").first})
  end
end

puts instagram_feed













