var config = {};

config.unittest = process.argv.indexOf('--unittest') > -1;

config.port = process.env.COCO_PORT || process.env.COCO_NODE_PORT || 3000;
config.ssl_port =
  process.env.COCO_SSL_PORT || process.env.COCO_SSL_NODE_PORT || 3443;

config.mongo = {};
config.mongo.port = process.env.COCO_MONGO_PORT || 27017;
config.mongo.host = process.env.COCO_MONGO_HOST || 'localhost';
config.mongo.db = process.env.COCO_MONGO_DATABASE_NAME || 'coco'

if (config.unittest) {
  config.port += 1;
  config.ssl_port += 1;
  config.mongo.host = 'localhost';
  console.log('uuu');
} else {
  config.mongo.username = process.env.COCO_MONGO_USERNAME || '';
  config.mongo.password = process.env.COCO_MONGO_PASSWORD || '';
}

config.cookie_secret = process.env.COCO_COOKIE_SECRET || 'chips ahoy';

config.isProduction = config.mongo.host !== 'localhost';

if (!config.unittest && !config.isProduction) {
  // change artificially slow down non-static requests for testing
  config.slow_down = false;
}

module.exports = config;
