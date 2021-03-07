// @1ts-check
const playwright = require('playwright');

(async () => {
  const browser = await playwright.webkit.launch();
  const context = await browser.newContext();
  const page = await context.newPage();
  page.route('**', (route, request) => {
    console.log(request.url());
    route.continue();
  });
  await page.goto('https://www.baidu.com');
  await page.screenshot({ path: `example.png` });
  await browser.close();
})();