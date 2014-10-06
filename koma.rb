# -*- coding: utf-8 -*-
require 'mechanize'
require 'optparse'

def cmdline
  args = {}
  OptionParser.new do |parser|
    parser.on('-n NUMBER', '登録番号') {|v| args[:number] = v}
    parser.on('-p PASS', '暗証番号') {|v| args[:pass] = v}
    parser.on('-d DATE', '年月日') {|v| args[:date] = v}
    parser.on('-t TIME', '1:0830-, 2:1030-, 3:1230-, 4:1430-, 5:1630-') {|v| args[:time] = v}
    parser.parse!(ARGV)
  end
  args
end

def get_form(tag, forms)
  for form in forms do
    if form.name == tag
      return form
    end
  end
  puts "no page " + tag
  puts forms.to_s
  exit
end

stimehash = {"1" => "0830", "2" => "1030", "3" => "1230", "4" => "1430", "5" => "1630"}
etimehash = {"1" => "1030", "2" => "1230", "3" => "1430", "4" => "1630", "5" => "1830"}

args = cmdline
if args[:number] == nil
  puts "登録番号がねえよ"
  exit
end
if args[:pass] == nil
  puts "暗証番号がねえよ"
  exit
end
stime = stimehash[args[:time]]
etime = etimehash[args[:time]]
if stime == nil || etime == nil
  puts "時間指定しろよ"
  exit
end

agent = Mechanize.new
page = agent.get('http://sports.tef.or.jp/default.asp')
page = agent.submit(get_form("REF1", page.forms))
form = get_form("frm", page.forms)
form.NUMBER = args[:number]
page = agent.submit(form)
form = get_form("frm", page.forms)
form.NUMBER = args[:pass]
page = agent.submit(form)
form = get_form("FRM1", page.forms)
form.CLASS = 3
page = agent.submit(form)
form = get_form("FRM1", page.forms)
form.EST = 2090  # 駒沢A面
p form
page = agent.submit(form)
form = get_form("FRM1", page.forms)
form.ITEM = 52 # 軟式野球（成人）
p form
page = agent.submit(form)
form = get_form("REFRSV_PAGE", page.forms)
p form
page = agent.submit(form)
form = get_form("FRM1", page.forms)
form.DATE = args[:date]
p form
page = agent.submit(form)
form = get_form("FRM1", page.forms)
form.DATE = args[:date]
form.PIE = args[:time]
form.STIME = stime
form.ETIME = etime
form.SELWAY = "1"
p form
page = agent.submit(form)
form = get_form("nextpg", page.forms)
page = agent.submit(form)
form = get_form("EXECRSV", page.forms)
page = agent.submit(form)
form = get_form("result", page.forms)
page = agent.submit(form)
p page.body
p page.forms
