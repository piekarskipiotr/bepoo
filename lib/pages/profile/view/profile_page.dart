import 'package:bepoo/di/get_it.dart';
import 'package:bepoo/l10n/l10n.dart';
import 'package:bepoo/pages/home/view/poost_item.dart';
import 'package:bepoo/pages/profile/bloc/profile_bloc.dart';
import 'package:bepoo/pages/profile/view/profile_header.dart';
import 'package:bepoo/pages/sign_in/bloc/auth_bloc.dart';
import 'package:bepoo/router/app_routes.dart';
import 'package:bepoo/widgets/app_bar_icon.dart';
import 'package:bepoo/widgets/loading_overlay/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(FetchPoosts(_focusedDay));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: context.read<ProfileBloc>(),
      listener: (context, state) {
        getIt<LoadingOverlayCubit>().changeLoadingState(
          isLoading: state is SavingAvatar,
        );
      },
      child: Scaffold(
        appBar: _appBar(context),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: Column(
                children: [
                  BlocBuilder(
                    bloc: context.read<ProfileBloc>(),
                    builder: (context, state) => BlocProvider.value(
                      value: context.read<ProfileBloc>(),
                      child: ProfileHeader(
                        user: context.read<AuthBloc>().getCurrentUser(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 16,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF181717),
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 8,
                        bottom: 16,
                      ),
                      child: TableCalendar(
                        firstDay: DateTime(2023, 8),
                        lastDay: DateTime.now(),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        calendarStyle: CalendarStyle(
                          defaultTextStyle: GoogleFonts.inter(),
                          weekendTextStyle: GoogleFonts.inter(),
                          todayDecoration: const BoxDecoration(
                            color: Color(0xFF8D7F7D),
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: const BoxDecoration(
                            color: Color(0xFF452F2B),
                            shape: BoxShape.circle,
                          ),
                          markerDecoration: const BoxDecoration(
                            color: Color(0xFFEED6A6),
                            shape: BoxShape.circle,
                          ),
                        ),
                        headerStyle: HeaderStyle(
                          titleCentered: true,
                          formatButtonVisible: false,
                          titleTextStyle: GoogleFonts.inter(fontSize: 16),
                        ),
                        eventLoader: (date) =>
                            context.read<ProfileBloc>().getPoostsCountByDate(
                                  date,
                                ),
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          context.read<ProfileBloc>().add(
                                FetchPoosts(selectedDay),
                              );

                          if (!isSameDay(_selectedDay, selectedDay)) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          }
                        },
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                      ),
                    ),
                  ),
                  BlocBuilder(
                    bloc: context.read<ProfileBloc>(),
                    builder: (context, state) {
                      final poosts = context.read<ProfileBloc>().poostsList;
                      if (state is FetchingPoosts) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: poosts.length,
                        itemBuilder: (context, index) => PoostItem(
                          poost: poosts[index],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    final l10n = context.l10n;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        l10n.profile,
        style: GoogleFonts.inter(),
      ),
      leadingWidth: 64,
      leading: AppBarIcon(
        onPressed: () => context.pop(),
        icon: Icons.arrow_back_ios_new,
        isLeading: true,
      ),
      actions: [
        AppBarIcon(
          onPressed: () => context.push(AppRoutes.settings),
          icon: Icons.settings,
        ),
      ],
    );
  }
}
