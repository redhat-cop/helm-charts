// eslint-disable-next-line no-unused-vars
const config = require('../../nightwatch.conf.js');

module.exports = {
  // adapted from: https://git.io/vodU0
  'Guinea Pig Assert Title': function (browser) {
    browser
      .url('https://saucelabs.com/test/guinea-pig')
      .waitForElementVisible('body')
      .assert.title('I am a page title - Sauce Labs')
      .saveScreenshot('guinea-pig-test.png')
      .end();
  },
};
