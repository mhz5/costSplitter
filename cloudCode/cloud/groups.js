exports.addGroup = function (members, userID, options) {


	var user = Parse.Object.extend("User");
	var query = new Parse.Query(user);
	query.get(userID, {
		success: function(res) {
			user = res;
			var groups = user.relation('groups');

			var Group = Parse.Object.extend('Group');
			var group = new Group();
			group.set('members', members);
			group.save({success: function(groupAgain) {
										groups.add(group);	// Add newly created group to the relation.	
										user.save();
										options.success();
									},
						error: function(groupAgain, error) {
										console.error(error)
										options.error();

									}
			});

		},
		error: function(object, error) {
			console.error(error);
			options.error();
		}
	});	
}