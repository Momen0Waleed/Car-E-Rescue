import 'dart:io';

import 'package:car_e_rescue/core/constants/api/api_constants.dart';
import 'package:car_e_rescue/core/constants/api/diagnostics_dio_client.dart';
import 'package:car_e_rescue/core/diagnostics/exceptions/diagnostic_exceptions.dart';
import 'package:car_e_rescue/core/diagnostics/models/diagnosis.dart';
import 'package:car_e_rescue/core/diagnostics/models/obd_snapshot.dart';
import 'package:car_e_rescue/core/diagnostics/state/diagnostic_session_state.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiagnosticService {
  static const String connectionOfflineMessage = 'Connection offline';

  DiagnosticService({
    Dio? dio,
    SharedPreferences? preferences,
  })  : _dio = dio ?? DiagnosticsDioClient.instance,
        _preferences = preferences;

  final Dio _dio;
  SharedPreferences? _preferences;

  Future<SharedPreferences> get _prefs async =>
      _preferences ??= await SharedPreferences.getInstance();

  Future<Options> _authOptions() async {
    final prefs = await _prefs;
    final token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      return Options();
    }

    return Options(
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<bool> isVehicleCalibrated(String vehicleId) async {
    final prefs = await _prefs;
    return prefs.getBool(ApiConstants.calibrationKey(vehicleId)) ?? false;
  }

  Future<void> _markVehicleCalibrated(String vehicleId) async {
    final prefs = await _prefs;
    await prefs.setBool(ApiConstants.calibrationKey(vehicleId), true);
  }

  Future<DiagnosticSessionState> startDiagnostics(String vehicleId) async {
    final calibrated = await isVehicleCalibrated(vehicleId);
    if (!calibrated) {
      return DiagnosticSessionState.requiresCalibration;
    }
    return DiagnosticSessionState.readyForMonitoring;
  }

  Future<DiagnosticSessionState> startDiagnosticsOrThrow(
    String vehicleId,
  ) async {
    final state = await startDiagnostics(vehicleId);
    if (state == DiagnosticSessionState.requiresCalibration) {
      throw VehicleNotCalibratedException(vehicleId);
    }
    return state;
  }

  Future<void> registerBaseline(
    String vehicleId,
    List<OBDSnapshot> snapshots,
  ) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.diagnosticsBaseline}/$vehicleId',
        data: snapshots.map((snapshot) => snapshot.toJson()).toList(),
        options: await _authOptions(),
      );

      if (response.statusCode == null ||
          response.statusCode! < 200 ||
          response.statusCode! >= 300) {
        throw DiagnosticException(
          'Baseline registration failed.',
          statusCode: response.statusCode,
        );
      }

      await _markVehicleCalibrated(vehicleId);
    } on DioException catch (error) {
      throw _mapDioException(error, 'Failed to register baseline.');
    } on SocketException {
      throw const DiagnosticException(connectionOfflineMessage);
    } catch (error) {
      if (error is DiagnosticException) rethrow;
      throw DiagnosticException(
        'Failed to register baseline.',
        cause: error,
      );
    }
  }

  Future<Diagnosis> analyzeWindow(
    String vehicleId,
    List<OBDSnapshot> snapshots,
  ) async {
    try {
      final response = await _dio.post(
        ApiConstants.diagnosticsAnalyzeWindow,
        data: {
          'vehicle_id': vehicleId,
          'snapshots': snapshots.map((snapshot) => snapshot.toJson()).toList(),
        },
        options: await _authOptions(),
      );

      return _parseDiagnosisResponse(response);
    } on DioException catch (error) {
      throw _mapDioException(error, 'Failed to analyze diagnostic window.');
    } on SocketException {
      throw const DiagnosticException(connectionOfflineMessage);
    } catch (error) {
      if (error is DiagnosticException) rethrow;
      throw DiagnosticException(
        'Failed to analyze diagnostic window.',
        cause: error,
      );
    }
  }




  Diagnosis _parseDiagnosisResponse(Response<dynamic> response) {
    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw DiagnosticException(
        'Unexpected diagnostic response.',
        statusCode: response.statusCode,
      );
    }

    if (response.data is! Map<String, dynamic>) {
      throw const DiagnosticException('Invalid diagnosis payload received.');
    }

    return Diagnosis.fromJson(response.data as Map<String, dynamic>);
  }

  DiagnosticException _mapDioException(DioException error, String fallback) {
    DiagnosticsDioClient.logError(error);

    final statusCode = error.response?.statusCode;
    final detail = error.response?.data;

    String message = fallback;
    if (detail is Map<String, dynamic>) {
      message = detail['detail']?.toString() ??
          detail['message']?.toString() ??
          fallback;
    } else if (detail is String && detail.isNotEmpty) {
      message = detail;
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      message = 'Request timed out. Please try again.';
    } else if (error.type == DioExceptionType.connectionError ||
        error.error is SocketException) {
      message = connectionOfflineMessage;
    }

    return DiagnosticException(
      message,
      statusCode: statusCode,
      cause: error,
    );
  }
}
