var friends = require('cloud/testFriends.js');
var auth = require('cloud/auth.js');

Parse.Cloud.define("getFriends", function(request, response) {
	var token;
	var url = "https://api.venmo.com/v1/users/1179328259817472900/friends";
	var userID = request.params.userID;
	console.log('User ID:' + userID);
	
	var user = Parse.Object.extend("User");
	var query = new Parse.Query(user);
	query.get(userID, {
		success: function(res) {
			user = res;
			token = res.get("access_token");
			console.log("Retrieved current user!");
			console.log('Access Token: ' + token);
			friends.getAllFriends(url, token,
				{success: function(input) {response.success(input)},
				error: function(input) {response.error(input)}});
		},
		error: function(object, error) {
			console.error("Error!!");
		}
	});
});


Parse.Cloud.define("requestAccessToken", function(request, response) {
	var code = request.params.code;
	var userID = request.params.userID;
	console.log(userID);
	auth.requestAccessToken(code, userID,
				{success: function(input) {response.success(input)},
				error: function(input) {response.error(input)}});
});
