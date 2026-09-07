import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/widgets/lumi_scaffold.dart';
import 'package:lumi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lumi/features/profile/presentation/bloc/profile_setup_bloc.dart';
import 'package:lumi/features/profile/presentation/widgets/profile_setup_card.dart';

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileSetupBloc, ProfileSetupState>(
      listenWhen: (previous, current) {
        return previous.status == ProfileSetupStatus.saving &&
            current.status == ProfileSetupStatus.saved;
      },
      listener: (BuildContext context, ProfileSetupState state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Profile updated.')));
        Navigator.of(context).pop();
      },
      child: LumiScaffold(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: 8,
              bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
            ),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (BuildContext context, AuthState authState) {
                    final String userId = authState.maybeWhen(
                      authenticated: (session) => session.userId,
                      orElse: () => '',
                    );
                    return BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
                      builder: (BuildContext context, ProfileSetupState state) {
                        return ProfileSetupCard(
                          state: state,
                          title: 'Edit your light',
                          subtitle:
                              'Adjust the name, avatar, and color your circle sees.',
                          submitLabel: 'Save profile',
                          onNameChanged: (String value) {
                            context.read<ProfileSetupBloc>().add(
                              ProfileSetupEvent.displayNameChanged(value),
                            );
                          },
                          onAvatarStyleChanged: (String value) {
                            context.read<ProfileSetupBloc>().add(
                              ProfileSetupEvent.avatarStyleChanged(value),
                            );
                          },
                          onColorSelected: (int value) {
                            context.read<ProfileSetupBloc>().add(
                              ProfileSetupEvent.signatureColorChanged(
                                value,
                                userId: userId,
                              ),
                            );
                          },
                          onSubmit: userId.isEmpty
                              ? () {}
                              : () {
                                  context.read<ProfileSetupBloc>().add(
                                    ProfileSetupEvent.submitted(userId: userId),
                                  );
                                },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
