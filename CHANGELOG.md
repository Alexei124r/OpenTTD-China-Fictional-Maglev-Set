# Changelog

## 0.1.2-alpha - 2026-11-04

- Added the TR2015 dining car, reusing the baggage/second-class composite
  sprites and adding 25% passenger comfort to the rest of the consist.
- Rebalanced TR08, TR2012 and TR2015 power, weight and tractive effort values.
- Renamed the cargo ageing parameter and vehicle descriptions to passenger
  comfort / freight freshness, with the values shown in each vehicle's
  purchase description.

## 0.1.1-alpha - 2026-11-03

- Renamed the passenger family to TR2015 and the freight family to TR2015F.
- Rebalanced TR08, TR2012, TR2015 and TR2015F power and weight values.
- Split the refrigerated-car power callback from the general freight car.

## 0.1.0-demo - 2026-11-01

Initial public demo.

- Added TR08 passenger head cars in three liveries.
- Added TR2012 passenger head cars in nine liveries.
- Added first-class and second-class intermediate cars.
- Added TR2015 passenger stock with Red Dragon, Silver Sword and Shanghai
  Metro Link liveries.
- Added TR2015 freight, refrigerated and baggage/second-class stock.
- Added MR2015 engineering and towing vehicle with consist-dependent speed
  and power isolation.
- Added configurable capacity, purchase cost, running cost, loading speed,
  mail capacity and cargo ageing.
- Added English and Simplified Chinese documentation.

Known limitations:

- This is a demo release and is not feature complete.
- A dining car and additional train models are planned for future releases.
- The set only applies its MR2015 power-isolation logic to vehicles in this
  GRF.

See `NML版本修改记录.txt` for the detailed development log.
