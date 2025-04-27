// Augment: TripOnBuddy Website → Flutter App
enum TransportMode {
  flight,
  train,
  bus,
  car,
  ferry,
}

extension TransportModeExtension on TransportMode {
  String get name {
    switch (this) {
      case TransportMode.flight:
        return 'Flight';
      case TransportMode.train:
        return 'Train';
      case TransportMode.bus:
        return 'Bus';
      case TransportMode.car:
        return 'Car';
      case TransportMode.ferry:
        return 'Ferry';
    }
  }

  String get icon {
    switch (this) {
      case TransportMode.flight:
        return 'flight';
      case TransportMode.train:
        return 'train';
      case TransportMode.bus:
        return 'directions_bus';
      case TransportMode.car:
        return 'directions_car';
      case TransportMode.ferry:
        return 'directions_boat';
    }
  }
}
