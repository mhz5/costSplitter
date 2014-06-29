exports.requestAccessToken = function(code, userID, options) {
	var baseUrl = 'https://api.venmo.com/v1/oauth/access_token'

	Parse.Cloud.httpRequest({
		method: 'POST',
		url: baseUrl,
		body: {
			client_id: '1777',
			client_secret: 'tXmuusxSDhex8FTVvUjUkQtRZmv3td7q',
			code: code
		},
		success: function(httpResponse) {
			
			var data = JSON.parse(httpResponse.text);
			var access_token = data.access_token;
			var refresh_token = data.refresh_token;

			var user = Parse.Object.extend("User");
			var query = new Parse.Query(user);
			query.get(userID, {
				success: function(res) {
					res.set('access_token', access_token);
					res.set('refresh_token', refresh_token);
					res.save();
					console.log('Saved user');
					options.success(access_token);
				},
				error: function(object, error) {
					console.error("Error!!");
				}
			});

			console.log(httpResponse.text);	
		},
		error: function(httpResponse) {
			console.error(httpResponse.text);
			options.error(httpResponse.text);
		}
	});
}