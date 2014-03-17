var config = {};

config.unittest = process.argv.indexOf('--unittest') > -1;

config.port = process.env.COCO_PORT || process.env.COCO_NODE_PORT || 3000;

config.mongo = {};
config.mongo.host = process.env.COCO_MONGO_HOST || 'localhost';

config.cookie_secret = process.env.COCO_COOKIE_SECRET || 'chips ahoy';

config.isProduction = config.mongo.host !== 'localhost';

if (!config.unittest && !config.isProduction) {
  // change artificially slow down non-static requests for testing
  config.slow_down = false;
}

module.exports = config;
