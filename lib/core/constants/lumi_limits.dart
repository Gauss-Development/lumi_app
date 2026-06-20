class LumiLimits {
  const LumiLimits._();

  static const int circleCap = 12;
  static const int maxCircleMembers = circleCap;
  static const int nameGlowHours = 6;
  static const int freeTierMemberCap = 3;
  static const int freeTierMembers = freeTierMemberCap;
  static const int paceLimitPerPairPer24Hours = 5;
  static const int paceLimitPerDay = paceLimitPerPairPer24Hours;
  static const int maxLumisPerPairPerDay = paceLimitPerPairPer24Hours;
  static const int householdPlanAccountCap = 6;
  static const Duration togetherMomentWindow = Duration(minutes: 1);
  static const Duration inviteLinkLifetime = Duration(hours: 24);
}
