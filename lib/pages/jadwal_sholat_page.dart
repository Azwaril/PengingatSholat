import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:adhan/adhan.dart';

class JadwalSholatPage extends StatefulWidget {
  @override
  _JadwalSholatPageState createState() => _JadwalSholatPageState();
}

class _JadwalSholatPageState extends State<JadwalSholatPage> {
  Map<String, DateTime?> prayerTimes = {};
  bool loading = true;
  String currentLocation = '';

  @override
  void initState() {
    super.initState();
    _getPrayerTimes();
  }

  Future<void> _getPrayerTimes() async {
    setState(() => loading = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location service disabled');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Permission denied forever');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await _loadPrayerTimes(position.latitude, position.longitude);
    } catch (e) {
      // Fallback ke Jakarta
      double fallbackLat = -6.2088; // Jakarta
      double fallbackLon = 106.8456;
      await _loadPrayerTimes(fallbackLat, fallbackLon, fallback: true);
    }
  }

  Future<void> _loadPrayerTimes(double lat, double lon, {bool fallback = false}) async {
    final coordinates = Coordinates(lat, lon);
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;

    final prayerTimesObj = PrayerTimes.today(coordinates, params);

    String city = '';
    String country = '';
    if (!fallback) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
        city = placemarks.first.locality ?? '';
        country = placemarks.first.country ?? '';
      } catch (_) {}
    }

    setState(() {
      prayerTimes = {
        'Subuh': prayerTimesObj.fajr,
        'Dzuhur': prayerTimesObj.dhuhr,
        'Ashar': prayerTimesObj.asr,
        'Maghrib': prayerTimesObj.maghrib,
        'Isya': prayerTimesObj.isha,
      };
      currentLocation = fallback
          ? 'Jakarta, Indonesia (default)'
          : (city.isNotEmpty ? '$city, $country' : 'Lokasi tidak diketahui');
      loading = false;
    });
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '-';
    return TimeOfDay.fromDateTime(time).format(context);
  }

  IconData _getIconForPrayer(String name) {
    switch (name) {
      case 'Subuh':
        return Icons.brightness_5;
      case 'Dzuhur':
        return Icons.wb_sunny;
      case 'Ashar':
        return Icons.brightness_6;
      case 'Maghrib':
        return Icons.nightlight_round;
      case 'Isya':
        return Icons.nights_stay;
      default:
        return Icons.access_time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade900, Colors.teal.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: loading
            ? Center(child: CircularProgressIndicator(color: Colors.white))
            : SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jadwal Sholat',
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  currentLocation,
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
                SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    children: prayerTimes.entries.map((entry) {
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Icon(_getIconForPrayer(entry.key),
                              color: Colors.teal, size: 30),
                          title: Text(
                            entry.key,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          trailing: Text(
                            _formatTime(entry.value),
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
