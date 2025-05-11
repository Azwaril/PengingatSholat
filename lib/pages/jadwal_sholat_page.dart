import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:adhan/adhan.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JadwalSholatPage extends StatefulWidget {
  @override
  _JadwalSholatPageState createState() => _JadwalSholatPageState();
}

class _JadwalSholatPageState extends State<JadwalSholatPage> {
  Map<String, DateTime?> prayerTimes = {};
  bool loading = true;
  bool adzanEnabled = false;
  String currentLocation = '';
  late AudioPlayer _audioPlayer;
  Timer? _checkPrayerTimeTimer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadAdzanSetting();
    _getPrayerTimes();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _checkPrayerTimeTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadAdzanSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      adzanEnabled = prefs.getBool('adzanEnabled') ?? false;
    });
  }

  Future<void> _setAdzanSetting(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('adzanEnabled', value);
    setState(() {
      adzanEnabled = value;
    });
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
    } catch (_) {
      await _loadPrayerTimes(-6.2088, 106.8456, fallback: true); // Jakarta
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

    _startPrayerTimeChecker();
  }

  void _startPrayerTimeChecker() {
    _checkPrayerTimeTimer = Timer.periodic(Duration(minutes: 1), (_) {
      if (!adzanEnabled) return;

      final now = DateTime.now();
      for (var time in prayerTimes.values) {
        if (time != null &&
            now.hour == time.hour &&
            now.minute == time.minute &&
            now.second < 10) {
          _playAdzan();
          break;
        }
      }
    });
  }

  void _playAdzan() async {
    if (!adzanEnabled) return;
    await _audioPlayer.play(AssetSource('audio/adzan.mp3'));
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
                Row(
                  children: [
                    Text(
                      'Jadwal Sholat',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text('Adzan', style: TextStyle(color: Colors.white)),
                        Switch(
                          value: adzanEnabled,
                          onChanged: (val) => _setAdzanSetting(val),
                          activeColor: Colors.white,
                        ),
                      ],
                    )
                  ],
                ),
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
                          leading: Icon(
                            _getIconForPrayer(entry.key),
                            color: Colors.teal,
                            size: 30,
                          ),
                          title: Text(
                            entry.key,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formatTime(entry.value),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: Icon(Icons.volume_up,
                                    color: Colors.teal),
                                onPressed: () {
                                  if (adzanEnabled) {
                                    _playAdzan();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Aktifkan audio adzan terlebih dahulu."),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
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
