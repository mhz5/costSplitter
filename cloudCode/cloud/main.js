Parse.Cloud.define("getFriends", function(request, response) {
	Parse.Cloud.httpRequest({
		url: "https://api.venmo.com/v1/users/1179328259817472900/friends?access_token=wCUpZsyUJG2n42A7cr3UL4CVNpG9ckNZ",
		success: function(httpResponse) {
			response.success(httpResponse.text);
		},
		error: function(httpResponse) {
			response.success("Request failed with response code " + httpResponse.status);
		}
	});
});
