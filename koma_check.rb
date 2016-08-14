# -*- coding: utf-8 -*-
require 'selenium-webdriver'
require 'optparse'

def cmdline
  args = {}
  OptionParser.new do |parser|
    parser.on('-n NUMBER', '登録番号') {|v| args[:number] = v}
    parser.on('-p PASS', '暗証番号') {|v| args[:pass] = v}
    parser.parse!(ARGV)
  end
  args
end

args = cmdline

userid = args[:number]
passwd = args[:pass]
day = args[:day].to_i - 1
time = args[:time].to_i

puts "ID: " + userid

driver = Selenium::WebDriver.for :chrome
driver.navigate.to 'https://sports.tef.or.jp/user/view/user/homeIndex.html'
elements = driver.find_elements(:id, 'goBtn')
elements[1].click

driver.find_element(:id, 'userid').send_keys(userid)
driver.find_element(:id, 'passwd').send_keys(passwd)
driver.find_element(:id, 'doLogin').click

#抽選の申し込み状況の一覧へ
next_pager = driver.find_element(:id, 'goLotStatusList')

while next_pager != nil
  next_pager.click
  driver.find_elements(:id, 'lotStateLabel').each do |e|
    if e.text.include?("落選")
      puts "ハズレ"
    elsif e.text.include?("当選")
      puts "当選！"
      exit
    end
  end
  elements = driver.find_elements(:id, 'goNextPager')
  if elements.length > 0
    next_pager = elements[0]
  else
    next_pager = nil
  end
end

driver.quit
