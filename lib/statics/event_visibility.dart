

enum EventVisability { public, friendsOnly, conunityOnly, private }


final Map<String, dynamic> eventVisibilityData = {
  'Public': EventVisability.public,
  'Friends Only': EventVisability.friendsOnly,
  'Community Only': EventVisability.conunityOnly,
  'Private': EventVisability.private,
};