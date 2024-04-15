// measurement_class.dart

class CustomerMeasurements {
  double height;
  double waist;
  double belly;
  double chest;
  double wrist;
  double neck;
  double arm;
  double thigh;
  double shoulder;
  double hips;
  bool saved; // Indicates whether measurements are saved or not

  CustomerMeasurements({
    required this.height,
    required this.waist,
    required this.belly,
    required this.chest,
    required this.wrist,
    required this.neck,
    required this.arm,
    required this.thigh,
    required this.shoulder,
    required this.hips,
    this.saved = false,
  });
}
