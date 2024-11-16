import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reservation_app/src/data/bloc/building/building_bloc.dart';
import 'package:reservation_app/src/data/bloc/user/user_bloc.dart';
import 'package:reservation_app/src/presentation/pages/profile/detail_profile.dart';
import 'package:reservation_app/src/presentation/pages/profile/edit_password.dart';
import 'package:reservation_app/src/presentation/pages/profile/profile_picture_full_screen.dart';

import '../../../data/bloc/extracurricular/extracurricular_bloc.dart';
import '../../../data/bloc/register/register_bloc.dart';
import '../../../data/model/building_model.dart';
import '../../../data/model/extracurricular_model.dart';
import '../../../data/model/user_model.dart';
import '../../pages/authentication/login.dart';
import '../../pages/botnavbar/botnavbar.dart';
import '../../pages/building/add_building.dart';
import '../../pages/building/page_building.dart';
import '../../pages/building/detail_building.dart';
import '../../pages/building/edit_building.dart';
import '../../pages/extracurricular/add_extracurricular.dart';
import '../../pages/extracurricular/detail_extracurricular.dart';
import '../../pages/extracurricular/edit_extracurricular.dart';
import '../../pages/history/history.dart';
import '../../pages/home/home.dart';
import '../../pages/profile/page_add_user.dart';
import '../../pages/profile/page_edit_user.dart';
import '../../pages/profile/page_profile.dart';
import '../../pages/reservation/confirm_reservation.dart';
import '../../pages/reservation/reservation.dart';
import '../../pages/splash/splash.dart';
import 'route_name.dart';

//User
final _navigatorHome = GlobalKey<NavigatorState>();
final _navigatorBuilding = GlobalKey<NavigatorState>();
final _navigatorReservation = GlobalKey<NavigatorState>();
final _navigatorHistory = GlobalKey<NavigatorState>();
final _navigatorProfile = GlobalKey<NavigatorState>();

//Admin
final _navigatorHomeAdmin = GlobalKey<NavigatorState>();
final _navigatorBuildingAdmin = GlobalKey<NavigatorState>();
final _navigatorReportAdmin = GlobalKey<NavigatorState>();
final _navigatorProfileAdmin = GlobalKey<NavigatorState>();

//Super Admin
final _navigatorHomeSuperAdmin = GlobalKey<NavigatorState>();
final _navigatorProfileSuperAdmin = GlobalKey<NavigatorState>();

final GoRouter routeApp = GoRouter(
  routes: <RouteBase>[
    /// without base route
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: Routes().login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/editPassword',
      name: Routes().editPassword,
      onExit: (context, state) {
        BlocProvider.of<UserBloc>(context).add(GetUserLoggedIn());
        return true;
      },
      builder: (context, state) {
        return EditPasswordPage(
          userModel: state.extra as UserModel,
        );
      },
    ),
    GoRoute(
      path: '/detailBuilding',
      name: Routes().detailBuilding,
      builder: (context, state) {
        return DetailBuilding(
          building: state.extra as BuildingModel,
        );
      },
    ),
    GoRoute(
      path: '/detailExtracurricular',
      name: Routes().detailExtracurricular,
      builder: (context, state) {
        return DetailExtracurricularPage(
          extracurricular: state.extra as ExtracurricularModel,
        );
      },
    ),
    GoRoute(
      path: '/profilePictureFullScreen',
      name: Routes().profilePictureFullScreen,
      builder: (context, state) {
        return ProfilePictureFullScreen(
          user: state.extra as UserModel,
        );
      },
    ),

    ///Navigation bottom bar for User
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BotNavBar(
          navigationShell: navigationShell,
        );
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          navigatorKey: _navigatorHome,
          routes: <RouteBase>[
            GoRoute(
              path: '/home',
              name: Routes().home,
              builder: (context, state) {
                return const HomePage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _navigatorBuilding,
          routes: <RouteBase>[
            GoRoute(
              path: '/building',
              name: Routes().building,
              builder: (context, state) {
                return const BuildingPage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _navigatorReservation,
          routes: <RouteBase>[
            GoRoute(
                path: '/reservation',
                name: Routes().reservation,
                builder: (context, state) {
                  return const ReservationPage();
                },
                routes: [
                  GoRoute(
                    path: 'confirmReservation',
                    name: Routes().confirmReservation,
                    builder: (context, state) {
                      return ConfirmReservationPage(
                        building: state.extra as BuildingModel,
                        dateStart:
                            state.uri.queryParameters["dateStart"] as String,
                        dateEnd: state.uri.queryParameters["dateEnd"] as String,
                      );
                    },
                  )
                ]),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _navigatorHistory,
          routes: <RouteBase>[
            GoRoute(
              path: '/history',
              name: Routes().history,
              builder: (context, state) {
                return const HistoryPage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _navigatorProfile,
          routes: <RouteBase>[
            GoRoute(
              path: '/profile',
              name: Routes().profile,
              builder: (context, state) {
                return const ProfilePage();
              },
            ),
          ],
        ),
      ],
    ),

    ///Navigation bottom bar for Admin
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BotNavBar(
          navigationShell: navigationShell,
        );
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          navigatorKey: _navigatorHomeAdmin,
          routes: <RouteBase>[
            GoRoute(
              path: '/homeAdmin',
              name: Routes().homeAdmin,
              builder: (context, state) {
                return const HomePage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _navigatorBuildingAdmin,
          routes: <RouteBase>[
            GoRoute(
              path: '/buildingAdmin',
              name: Routes().buildingAdmin,
              builder: (context, state) {
                return const BuildingPage();
              },
              routes: [
                GoRoute(
                  path: 'createBuilding',
                  name: Routes().createBuilding,
                  builder: (context, state) {
                    return const AddBuildingPage();
                  },
                  onExit: (context, state) {
                    BlocProvider.of<BuildingBloc>(context)
                        .add(GetBuildingByAgency());
                    return true;
                  },
                  routes: [
                    GoRoute(
                      path: 'editBuilding',
                      name: Routes().editBuilding,
                      builder: (context, state) {
                        return EditBuildingPage(
                          building: state.extra as BuildingModel,
                        );
                      },
                      onExit: (context, state) {
                        BlocProvider.of<BuildingBloc>(context)
                            .add(GetBuildingByAgency());
                        return true;
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: 'createExtracurricular',
                  name: Routes().createExtracurricular,
                  builder: (context, state) {
                    return const AddExtracurricularPage();
                  },
                  onExit: (context, state) {
                    BlocProvider.of<ExtracurricularBloc>(context)
                        .add(GetExtracurricular());
                    return true;
                  },
                  routes: [
                    GoRoute(
                      path: 'editExtracurricular',
                      name: Routes().editExtracurricular,
                      builder: (context, state) {
                        return EditExtracurricularPage(
                          excur: state.extra as ExtracurricularModel,
                        );
                      },
                      onExit: (context, state) {
                        BlocProvider.of<ExtracurricularBloc>(context)
                            .add(GetExtracurricular());
                        return true;
                      },
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _navigatorReportAdmin,
          routes: <RouteBase>[
            GoRoute(
              path: '/reportAdmin',
              name: Routes().reportAdmin,
              builder: (context, state) {
                return const HistoryPage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _navigatorProfileAdmin,
          routes: <RouteBase>[
            GoRoute(
              path: '/profileAdmin',
              name: Routes().profileAdmin,
              builder: (context, state) {
                return const ProfilePage();
              },
              routes: [
                GoRoute(
                  path: 'addUser',
                  name: Routes().addUser,
                  builder: (context, state) {
                    return AddUserPage(
                      userModel: state.extra as UserModel,
                    );
                  },
                ),
                GoRoute(
                  path: 'editUser',
                  name: Routes().editUser,
                  builder: (context, state) {
                    return EditUserPage(
                      userModel: state.extra as UserModel,
                    );
                  },
                  onExit: (context, state) {
                    BlocProvider.of<RegisterBloc>(context)
                        .add(GetAllUserAdmin());
                    return true;
                  },
                ),
                GoRoute(
                  path: 'detailUser',
                  name: Routes().detailUser,
                  builder: (context, state) {
                    return DetailProfilePage(
                      userModel: state.extra as UserModel,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    ///Navigation bottom bar for Super Admin
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BotNavBar(
          navigationShell: navigationShell,
        );
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          navigatorKey: _navigatorHomeSuperAdmin,
          routes: <RouteBase>[
            GoRoute(
              path: '/homeSuperAdmin',
              name: Routes().homeSuperAdmin,
              builder: (context, state) {
                return const HomePage();
              },
              routes: [
                GoRoute(
                  path: 'addUserSuperAdmin',
                  name: Routes().addUserSuperAdmin,
                  builder: (context, state) {
                    return AddUserPage(
                      userModel: state.extra as UserModel,
                    );
                  },
                ),
                GoRoute(
                  path: 'editUserSuperAdmin',
                  name: Routes().editUserSuperAdmin,
                  builder: (context, state) {
                    return EditUserPage(
                      userModel: state.extra as UserModel,
                    );
                  },
                  onExit: (context, state) {
                    BlocProvider.of<RegisterBloc>(context)
                        .add(GetAllUserSuperAdmin());
                    return true;
                  },
                ),
                GoRoute(
                  path: 'detailUserSuperAdmin',
                  name: Routes().detailUserSuperAdmin,
                  builder: (context, state) {
                    return DetailProfilePage(
                      userModel: state.extra as UserModel,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _navigatorProfileSuperAdmin,
          routes: <RouteBase>[
            GoRoute(
              path: '/profileSuperAdmin',
              name: Routes().profileSuperAdmin,
              builder: (context, state) {
                return const ProfilePage();
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
