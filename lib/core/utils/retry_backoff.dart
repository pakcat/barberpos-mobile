Duration computeRetryBackoff(
  int attempts, {
  Duration base = const Duration(seconds: 5),
  Duration max = const Duration(minutes: 5),
}) {
  if (attempts <= 0) return Duration.zero;
  // Stop being aggressive after many failures to avoid battery/network drain.
  // At this point we effectively "pause" retries and require manual retry from Sync UI.
  if (attempts >= 8) return const Duration(days: 365);
  final exponent = (attempts - 1).clamp(0, 30);
  final seconds = base.inSeconds * (1 << exponent);
  final duration = Duration(seconds: seconds);
  return duration > max ? max : duration;
}
