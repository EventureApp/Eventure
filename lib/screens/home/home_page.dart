import 'package:eventure/models/event_filter.dart';
import 'package:eventure/models/user.dart';
import 'package:eventure/providers/event_provider.dart';
import 'package:eventure/providers/location_provider.dart';
import 'package:eventure/providers/user_provider.dart';
import 'package:eventure/screens/list/list_screen.dart';
import 'package:eventure/widgets/map.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../statics/custom_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool isMapSelected = true;

  bool areFiltersApplied(EventFilter filter) {
    return !(filter.eventType == null &&
        filter.endDate == null &&
        filter.startDate == null);
  }

  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false)
        .fetchCurrentLocation();
  }

  void _optionsDialog(BuildContext context, AppUser user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    user.profilePicture as String? ??
                        'https://i.pravatar.cc/300',
                  ),
                ),
                title: Text(
                  "${user.firstName ?? 'User'} ${user.lastName ?? 'Name'}",
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('My Profile'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/profile');
                },
              ),
              ListTile(
                leading: const Icon(Icons.group),
                title: const Text('User'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/userList');
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/settings');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 140,
        title: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Consumer<EventProvider>(
                      builder: (context, eventProvider, child) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: (Theme.of(context).colorScheme.surface),

                            ),
                            onChanged: (value) {
                              eventProvider.setSearchString(value);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      final user = userProvider.user;
                      return IconButton(
                        icon: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            user.profilePicture as String? ??
                                'https://i.pravatar.cc/300',
                          ),
                        ),
                        onPressed: () {
                          _optionsDialog(context, user);
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 8),
              Consumer<EventProvider>(
                builder: (context, eventProvider, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: ElevatedButton(
                          onPressed: () {
                            EventFilter newFilter = eventProvider.filter;
                            if (eventProvider.filter.startDate !=
                                DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day,
                                ) &&
                                eventProvider.filter.endDate !=
                                    DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day + 1,
                                    )) {
                              newFilter.startDate = DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                              );
                              newFilter.endDate = DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day + 1,
                              );
                              eventProvider.setFilter(newFilter);
                            } else {
                              newFilter.startDate = null;
                              newFilter.endDate = null;
                              eventProvider.setFilter(newFilter);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.secondary,
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            textStyle: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          child: const Text('Today'),
                        ),
                      ),
                      Flexible(
                        child: ElevatedButton(
                          onPressed: () {
                            EventFilter newFilter = eventProvider.filter;
                            if (eventProvider.filter.startDate !=
                                DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day + 1,
                                ) &&
                                eventProvider.filter.endDate !=
                                    DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day + 2,
                                    )) {
                              newFilter.startDate = DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day + 1,
                              );
                              newFilter.endDate = DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day + 2,
                              );
                              eventProvider.setFilter(newFilter);
                            } else {
                              newFilter.startDate = null;
                              newFilter.endDate = null;
                              eventProvider.setFilter(newFilter);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.secondary,
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            textStyle: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          child: const Text('Tomorrow'),
                        ),
                      ),
                      Flexible(
                        child: ElevatedButton(
                          onPressed: () {
                            EventFilter newFilter = eventProvider.filter;
                            if (eventProvider.filter.startDate !=
                                DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day,
                                ) &&
                                eventProvider.filter.endDate !=
                                    DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day + 7,
                                    )) {
                              newFilter.startDate = DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                              );
                              newFilter.endDate = DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day + 7,
                              );
                              eventProvider.setFilter(newFilter);
                            } else {
                              newFilter.startDate = null;
                              newFilter.endDate = null;
                              eventProvider.setFilter(newFilter);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.secondary,
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            textStyle: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          child: const Text('One Week'),
                        ),
                      ),
                    ],
                  );
                },
              ),

            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Consumer2<LocationProvider, EventProvider>(
            builder: (context, locationProvider, eventProvider, child) {
              if (locationProvider.currentLocation == null) {
                return const Center(
                  child: CircularProgressIndicator(), // Loading state
                );
              }

              return isMapSelected
                  ? MapWidget(
                      currentLocation: locationProvider.currentLocation!,
                      currentSelectedLocation: eventProvider.filter.location,
                    )
                  : const ListScreen();
            },
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 90,
        child: BottomAppBar(
          color: Theme.of(context).colorScheme.primary,
          elevation: 4,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Left buttons
              Positioned(
                left: 20, // Adjust this value to control the horizontal position
                child: Row(
                  children: [
                    Consumer<EventProvider>(
                        builder: (context, eventProvider, child) {
                          return Stack(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  CustomIcons.filterOptions,
                                  size: 24,
                                ),
                                onPressed: () {
                                  context.push('/addFilter');
                                },
                              ),
                              if (areFiltersApplied(eventProvider.filter))
                                const Positioned(
                                    right: 8,
                                    top: 8,
                                    child: CircleAvatar(
                                      radius: 4,
                                      backgroundColor: Colors.blueAccent,
                                    ))
                            ],
                          );
                        }),
                    IconButton(
                      icon: const Icon(
                        Icons.location_pin,
                        size: 24,
                      ),
                      onPressed: () {
                        context.push('/setLocation');
                      },
                    ),
                  ],
                ),
              ),
              // Centered toggle button
              Center(
                child: ToggleButtons(
                  isSelected: [isMapSelected, !isMapSelected],
                  onPressed: (int index) {
                    setState(() {
                      isMapSelected = index == 0;
                    });
                  },
                  borderRadius: BorderRadius.circular(20.0),
                  color: Theme.of(context).colorScheme.secondary,
                  selectedColor: Theme.of(context).colorScheme.secondary,
                  fillColor: Theme.of(context).primaryColor,
                  splashColor: Colors.transparent,
                  children: const [
                    Icon(CustomIcons.map, size: 24),
                    Icon(Icons.list, size: 24),
                  ],
                ),
              ),
              // Right button
              Positioned(
                right: 20, // Adjust this value to control the horizontal position
                child: IconButton(
                  icon: const Icon(
                    CustomIcons.plus,
                    size: 24,
                  ),
                  onPressed: () {
                    context.push('/addEvent');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
