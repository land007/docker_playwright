// @1ts-check
const { chromium } = require('playwright');
const { saveVideo } = require('playwright-video');
const path = require('path');

(async () => {
  const timeout = function(ms){
    return new Promise(resolve => setTimeout(resolve, ms))
  }
  const browser = await chromium.launch();
  const context = await browser.newContext();
  const page = await context.newPage();
  await saveVideo(page, __dirname + path.sep +'video.mp4');
  page.route('**', (route, request) => {
    console.log(request.url());
    route.continue();
  });
  await page.goto('https://www.baidu.com');
  await timeout(5000);
  await page.screenshot({ path: __dirname + path.sep + `example.png` , fullPage: true});
  console.log('save example.png');
  await browser.close();
})();