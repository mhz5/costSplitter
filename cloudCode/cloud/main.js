var test = require('cloud/test.js');


Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("goodbye", function(request, response) {
	response.success(test.goodbye());
});
