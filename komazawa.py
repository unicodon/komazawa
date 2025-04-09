from selenium import webdriver
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.common.by import By
from selenium.webdriver.common.alert import Alert
from selenium.common.exceptions import StaleElementReferenceException
from time import sleep
import argparse


def run(day, time, username, password):
    browser = webdriver.Chrome()
    browser.get('https://sports.tef.or.jp/user/view/user/homeIndex.html')

    timeout = 100
    #ログイン
    WebDriverWait(browser, timeout).until(lambda x: x.find_element(By.ID, 'login')).click()
    WebDriverWait(browser, timeout).until(lambda x: x.find_element(By.ID, 'userid')).send_keys(username)
    WebDriverWait(browser, timeout).until(lambda x: x.find_element(By.ID, 'passwd')).send_keys(password)
    WebDriverWait(browser, timeout).until(lambda x: x.find_element(By.ID, 'doLogin')).click()

    #新規抽選を申し込む
    WebDriverWait(browser, timeout).until(lambda x: x.find_element(By.ID, 'goLotSerach')).click()
    
    #野球を選択
    WebDriverWait(browser, timeout).until(lambda x: x.find_elements(By.ID, 'clscd'))[0].click()
    WebDriverWait(browser, timeout).until(lambda x: x.find_element(By.ID, 'doSearch')).click()
    
    #施設を選択
    # 0:軟式野球場A面
    WebDriverWait(browser, timeout).until(lambda x: x.find_elements(By.ID, 'doAreaSet'))[0].click()
    
    for i in range(0, 7):
        #日にちを選択
        WebDriverWait(browser, timeout).until(lambda x: x.find_elements(By.CLASS_NAME, 'calclick'))[day].click()

        WebDriverWait(browser, timeout).until(lambda x: str(day+1) + '日' in x.find_element(By.ID, 'targetLabel').text)

        #時間を選択
        WebDriverWait(browser, timeout).until(lambda x: x.find_elements(By.ID, 'chkKom-1'))[time].click()
        WebDriverWait(browser, timeout).until(lambda x: x.find_element(By.ID, 'doDateTimeSet')).click()

        #内容確認
        WebDriverWait(browser, timeout).until(lambda x: x.find_element(By.ID, 'makeList')).find_elements(By.TAG_NAME, 'option')[-1].click()
        WebDriverWait(browser, timeout).until(lambda x: x.find_element(By.ID, 'eventname')).send_keys('草野球')
        WebDriverWait(browser, timeout).until(lambda x: x.find_element(By.ID, 'applycnt')).send_keys('20')
        WebDriverWait(browser, timeout).until(lambda x: x.find_element(By.ID, 'doConfirm')).click()

        #最終確認
        WebDriverWait(browser, timeout).until(lambda x: x.find_element(By.ID, 'doOnceFix')).click()
        Alert(browser).accept()
    
        #次
        WebDriverWait(browser, timeout).until(lambda x: x.find_element(By.ID, 'doDateSearch')).click()
    sleep(3)

parser = argparse.ArgumentParser()
parser.add_argument('-u', '--username', required=True)
parser.add_argument('-p', '--password', required=True)
parser.add_argument('-d', '--day', type=int, required=True, help='1=1日')
parser.add_argument('-t', '--time', type=int, required=True, help='0:0830-, 1:1030-, 2:1230-, 3:1430-, 4:1630-')
args = parser.parse_args()
run(args.day - 1, args.time, args.username, args.password)

