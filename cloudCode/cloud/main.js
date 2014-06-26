var friends = require('cloud/testFriends.js');

Parse.Cloud.define("getFriends", function(request, response) {
	var url = "https://api.venmo.com/v1/users/1179328259817472900/friends" 
	var token = "wCUpZsyUJG2n42A7cr3UL4CVNpG9ckNZ"

	friends.getAllFriends(url, token,
		{success: function(input) {response.success(input)},
		 error: function(input) {response.error(input)}});

});
