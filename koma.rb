# -*- coding: utf-8 -*-
require 'selenium-webdriver'
require 'optparse'

def cmdline
  args = {}
  OptionParser.new do |parser|
    parser.on('-n NUMBER', '登録番号') {|v| args[:number] = v}
    parser.on('-p PASS', '暗証番号') {|v| args[:pass] = v}
    parser.on('-d DAY', '日') {|v| args[:day] = v}
    parser.on('-t TIME', '0:0830-, 1:1030-, 2:1230-, 3:1430-, 4:1630-') {|v| args[:time] = v}
    parser.parse!(ARGV)
  end
  args
end

args = cmdline

userid = args[:number]
passwd = args[:pass]
day = args[:day].to_i - 1
time = args[:time].to_i
puts "User ID #{userid}"

driver = Selenium::WebDriver.for :chrome
driver.navigate.to 'https://sports.tef.or.jp/user/view/user/homeIndex.html'
elements = driver.find_elements(:id, 'goBtn')
elements[1].click

driver.find_element(:id, 'userid').send_keys(userid)
driver.find_element(:id, 'passwd').send_keys(passwd)
driver.find_element(:id, 'doLogin').click

#新規抽選を申し込む
driver.find_element(:id, 'goLotSerach').click #typo :(

#野球を選択
driver.find_elements(:id, 'clscd')[0].click
driver.find_element(:id, 'doSearch').click

#施設を選択
# 0:軟式野球場A面
driver.find_elements(:id, 'doAreaSet')[0].click

for num in 1..7 do

  #日にちを選択
  driver.find_elements(:class_name, 'calclick')[day].click

  #時間を選択
  driver.find_elements(:id, 'chkKom-1')[time].click
  driver.find_element(:id, 'doDateTimeSet').click

  #内容確認
  selection = driver.find_element(:id, "makeList")
  options = selection.find_elements(:tag_name, "option")
  options[options.size - 1].click
  driver.find_element(:id, "applycnt").send_keys("20")
  driver.find_element(:id, "doConfirm").click

  #最終確認
  driver.find_element(:id, "doOnceFix").click
  alert = driver.switch_to.alert
  alert.accept

  #次
  driver.find_element(:id, "doDateSearch").click
end

driver.quit
