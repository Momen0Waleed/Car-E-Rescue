import 'dart:async';

import 'package:car_e_rescue/core/diagnostics/diagnostic_service.dart';
import 'package:car_e_rescue/core/diagnostics/exceptions/diagnostic_exceptions.dart';
import 'package:car_e_rescue/core/diagnostics/models/diagnosis.dart';
import 'package:car_e_rescue/core/diagnostics/models/obd_snapshot.dart';
import 'package:car_e_rescue/core/diagnostics/state/diagnostic_session_state.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_diagnose/model/obd_sensor_data_model.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_diagnose/model/obd_snapshot_mapper.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_diagnose/model/user_diagnose_repo.dart';

class UserDiagnoseViewModel {
  UserDiagnoseViewModel({
    required String vehicleId,
    DiagnosticService? diagnosticService,
    UserDiagnoseRepo? repo,
  })  : _vehicleId = vehicleId,
        _diagnosticService = diagnosticService ?? DiagnosticService(),
        _repo = repo ?? UserDiagnoseRepo();

  final String _vehicleId;
  final DiagnosticService _diagnosticService;
  final UserDiagnoseRepo _repo;

  static const int _bufferMax = 60;

  final List<OBDSnapshot> _snapshotBuffer = [];
  StreamSubscription<ObdSensorDataModel>? _sensorSubscription;

  final _sessionStateController =
      StreamController<DiagnosticSessionState>.broadcast();
  final _diagnosisController = StreamController<Diagnosis?>.broadcast();
  final _loadingController = StreamController<bool>.broadcast();
  final _calibrationProgressController = StreamController<int>.broadcast();
  final _calibratingController = StreamController<bool>.broadcast();
  final _calibrationCompleteController = StreamController<void>.broadcast();
  final _errorController = StreamController<String>.broadcast();

  bool _isCalibrating = false;
  int _calibrationCollected = 0;
  ObdSensorDataModel _latestSensorData = ObdSensorDataModel();

  Stream<String> get statusStream => _repo.statusStream;
  String get currentStatus => _repo.currentStatus;
  Stream<ObdSensorDataModel> get sensorDataStream =>
      _repo.rawDataStream.map((map) => ObdSensorDataModel.fromMap(map));

  Stream<DiagnosticSessionState> get sessionStateStream =>
      _sessionStateController.stream;

  Stream<Diagnosis?> get diagnosisStream => _diagnosisController.stream;
  Stream<bool> get loadingStream => _loadingController.stream;
  Stream<int> get calibrationProgressStream =>
      _calibrationProgressController.stream;
  Stream<bool> get calibratingStream => _calibratingController.stream;
  Stream<void> get calibrationCompleteStream =>
      _calibrationCompleteController.stream;
  Stream<String> get errorStream => _errorController.stream;

  String get vehicleId => _vehicleId;
  int get snapshotBufferSize => _snapshotBuffer.length;
  bool get isCalibrating => _isCalibrating;

  Future<void> initialize() async {
    _listenToSensorData();
    await refreshSessionState();
  }

  void _listenToSensorData() {
    _sensorSubscription?.cancel();
    _sensorSubscription = sensorDataStream.listen((data) {
      _latestSensorData = data;
      _appendSnapshot(data);
    });
  }

  void _appendSnapshot(ObdSensorDataModel data) {
    final snapshot = ObdSnapshotMapper.fromSensorData(
      vehicleId: _vehicleId,
      data: data,
    );

    _snapshotBuffer.add(snapshot);
    if (_snapshotBuffer.length > _bufferMax) {
      _snapshotBuffer.removeAt(0);
    }

    if (_isCalibrating) {
      _calibrationCollected = _snapshotBuffer.length.clamp(
        0,
        ObdSnapshotMapper.baselineSnapshotCount,
      );
      _calibrationProgressController.add(_calibrationCollected);

      if (_calibrationCollected >= ObdSnapshotMapper.baselineSnapshotCount) {
        unawaited(_submitCalibration());
      }
    }
  }

  Future<void> refreshSessionState() async {
    try {
      final state = await _diagnosticService.startDiagnostics(_vehicleId);
      _sessionStateController.add(state);
    } catch (error) {
      _errorController.add(_messageFrom(error));
    }
  }

  Future<bool> isVehicleCalibrated() =>
      _diagnosticService.isVehicleCalibrated(_vehicleId);

  void startConnection() {
    _repo.connect();
  }

  Future<void> startCalibrationCollection() async {
    _snapshotBuffer.clear();
    _calibrationCollected = 0;
    _isCalibrating = true;
    _calibratingController.add(true);
    _calibrationProgressController.add(0);
  }

  void cancelCalibrationCollection() {
    _isCalibrating = false;
    _calibratingController.add(false);
    _calibrationProgressController.add(0);
  }

  Future<void> _submitCalibration() async {
    if (!_isCalibrating) return;

    _isCalibrating = false;
    _calibratingController.add(false);
    _setLoading(true);

    try {
      final snapshots = List<OBDSnapshot>.from(_snapshotBuffer);
      await _diagnosticService.registerBaseline(_vehicleId, snapshots);
      _sessionStateController.add(DiagnosticSessionState.readyForMonitoring);
      _calibrationProgressController.add(ObdSnapshotMapper.baselineSnapshotCount);
      _calibrationCompleteController.add(null);
    } catch (error) {
      _errorController.add(_messageFrom(error));
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<Diagnosis?> runWindowAnalysis() async {
    final state = await _diagnosticService.startDiagnostics(_vehicleId);
    if (state == DiagnosticSessionState.requiresCalibration) {
      _sessionStateController.add(state);
      _errorController.add('Calibrate your vehicle before running diagnostics.');
      return null;
    }

    if (_snapshotBuffer.length < ObdSnapshotMapper.windowSnapshotCount) {
      _errorController.add(
        'Collecting data... need ${ObdSnapshotMapper.windowSnapshotCount} '
        'readings (${_snapshotBuffer.length} so far). Keep the sensor connected.',
      );
      return null;
    }

    _setLoading(true);
    try {
      final window = _snapshotBuffer
          .skip(_snapshotBuffer.length - ObdSnapshotMapper.windowSnapshotCount)
          .toList();

      final diagnosis =
          await _diagnosticService.analyzeWindow(_vehicleId, window);
      _diagnosisController.add(diagnosis);
      return diagnosis;
    } catch (error) {
      _errorController.add(_messageFrom(error));
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<Diagnosis?> runEmergencyAnalysis() async {
    _setLoading(true);
    try {
      final snapshot = ObdSnapshotMapper.fromSensorData(
        vehicleId: _vehicleId,
        data: _latestSensorData,
      );
      final diagnosis = await _diagnosticService.analyzeEmergency(snapshot);
      _diagnosisController.add(diagnosis);
      return diagnosis;
    } catch (error) {
      _errorController.add(_messageFrom(error));
      return null;
    } finally {
      _setLoading(false);
    }
  }

  void clearDiagnosis() {
    _diagnosisController.add(null);
  }

  void _setLoading(bool value) {
    _loadingController.add(value);
  }

  String _messageFrom(Object error) {
    if (error is DiagnosticException) return error.message;
    return error.toString();
  }

  void dispose() {
    _sensorSubscription?.cancel();
    _repo.dispose();
    _sessionStateController.close();
    _diagnosisController.close();
    _loadingController.close();
    _calibrationProgressController.close();
    _calibratingController.close();
    _calibrationCompleteController.close();
    _errorController.close();
  }
}
