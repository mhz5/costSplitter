exports.getAllFriends = function(url, token, options) {
	var emptyFriends = {}
	getFriends(url, token, emptyFriends, options);
}

// Returns an array of the current user's friends.
function getFriends(url, token, friends, options) {
	var actualURL;
	if (Object.keys(friends).length == 0)
		actualURL = url + '?access_token=' + token;
	else
		actualURL = url + '&access_token=' + token;
	
	actualURL = actualURL + '&limit=50';

	console.log(actualURL);
	Parse.Cloud.httpRequest({
		url: actualURL,
		success: function(httpResponse) {
			var data = JSON.parse(httpResponse.text);
			// Need to call getFriends() on the next page of friends.
			var nextPage = data.pagination.next;
			if (nextPage == null)
				options.success(friends);
			
			for (i in data.data) {
				var obj = data.data[i];
				// console.log(obj);
				var name = obj.display_name;
				// console.log(name);
				var id = obj.id;
				console.log(id);
				friends[name] = id;
			}

			getFriends(nextPage, token, friends, options);
		},
		error: function(httpResponse) {
			options.error("Request failed with response code " + httpResponse.status);
		}
	});
}
