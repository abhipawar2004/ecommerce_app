import 'dart:convert';

import 'running_flash_sale.dart';

class Data {
  List<RunningFlashSale> incomingFlashSale;
  List<RunningFlashSale> runningFlashSale;

  Data({
    this.incomingFlashSale = const [],
    this.runningFlashSale = const [],
  });

  factory Data.fromMap(Map<String, dynamic> data) => Data(
        incomingFlashSale: data['incoming_flash_sale'] == null
            ? []
            : List<RunningFlashSale>.from(
                (data['incoming_flash_sale'] as List<dynamic>).map((e) =>
                    RunningFlashSale.fromMap(e as Map<String, dynamic>))),
        runningFlashSale: data['running_flash_sale'] == null
            ? []
            : List<RunningFlashSale>.from(
                (data['running_flash_sale'] as List<dynamic>).map(
                    (e) => RunningFlashSale.fromMap(e as Map<String, dynamic>)),
              ),
      );

  Map<String, dynamic> toMap() => {
        'incoming_flash_sale': incomingFlashSale,
        'running_flash_sale': runningFlashSale.map((e) => e.toMap()).toList(),
      };

  factory Data.fromJson(String data) {
    return Data.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}
