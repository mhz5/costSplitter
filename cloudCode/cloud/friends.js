exports.getAllFriends = function(url, token, options) {
    Parse.Cloud.httpRequest({
        url: url + token,
        success: function(httpResponse) {
            var data = JSON.parse(httpResponse.text);
            var nextPage = data.pagination.next;
            console.log(nextPage);
 
            options.success(httpResponse.text);
        },
        error: function(httpResponse) {
            options.error("Request failed with response code " + httpResponse.status);
        }
    });
}