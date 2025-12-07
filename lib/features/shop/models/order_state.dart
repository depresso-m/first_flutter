import 'order.dart';

enum OrderStatus { received, formed, assembled, handed }

const Duration kReceivedDuration = Duration(seconds: 15);
const Duration kFormedDuration = Duration(seconds: 30);
const Duration kAssembledDuration = Duration(seconds: 30);

OrderStatus getOrderStatusAt(Order order, DateTime now) {
  final elapsed = now.difference(order.date);
  if (elapsed < kReceivedDuration) return OrderStatus.received;
  if (elapsed < kReceivedDuration + kFormedDuration) return OrderStatus.formed;
  if (elapsed < kReceivedDuration + kFormedDuration + kAssembledDuration) {
    return OrderStatus.assembled;
  }
  return OrderStatus.handed;
}

double getOrderProgressAt(Order order, DateTime now) {
  final elapsed = now.difference(order.date);
  final totalDuration =
      kReceivedDuration + kFormedDuration + kAssembledDuration;
  if (elapsed.isNegative) return 0.0;
  if (elapsed >= totalDuration) return 1.0;
  return (elapsed.inMilliseconds / totalDuration.inMilliseconds).clamp(
    0.0,
    1.0,
  );
}
