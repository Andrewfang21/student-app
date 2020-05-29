String getPageString(String page) {
  return page.split('.')[1];
}

bool isSame(String pageName, String pageNameEnum) {
  return pageName == getPageString(pageNameEnum);
}
