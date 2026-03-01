import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_diagnose/model/obd_sensor_data_model.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_diagnose/view_model/user_diagnose_view_model.dart';
import 'package:car_e_rescue/modules/widgets/custom_button.dart';
import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
import 'package:flutter/material.dart';

class UserDiagnoseView extends StatefulWidget {
  const UserDiagnoseView({super.key});

  @override
  State<UserDiagnoseView> createState() => _UserDiagnoseViewState();
}

class _UserDiagnoseViewState extends State<UserDiagnoseView> {
  final UserDiagnoseViewModel _viewModel = UserDiagnoseViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: NavigateBackButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Padding(
        padding: const EdgeInsets.only(left: 16,right: 16,top: 50,bottom: 20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
                color: AppColors.pink
          ),
          child: StreamBuilder<ObdSensorDataModel>(
            stream: _viewModel.sensorDataStream,
            initialData: ObdSensorDataModel(),
            builder: (context, snapshot) {
              final data = snapshot.data!;
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  StreamBuilder<String>(
                    stream: _viewModel.statusStream,
                    initialData: "Disconnected",
                    builder: (c, s) => Center(
                      child: Text("Status: ${s.data}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                      ),
                    ),
                  ),
                  Divider(color: AppColors.white,thickness: 2,indent: 50,endIndent: 50,),
                  _buildTile("Engine RPM", data.rpm, "RPM"),
                  _buildTile("Vehicle Speed", data.speed, "km/h"),
                  _buildTile("Coolant Temp", data.coolantTemp, "°C"),
                  _buildTile("Battery Voltage", data.voltage, "V"),
                  _buildTile("Fuel Level", data.fuelLevel, "%"),
                  _buildTile("Throttle Position", data.throttle, "%"),
                  _buildTile("Ambient Air Temp", data.ambientTemp, "°C"),
                  _buildTile("Oil Temp", data.oilTemp, "°C"),
                  _buildTile("Runtime", data.runtime, "min"),
                  // _buildTile("Barometric Pressure", data.baro, "kPa"),
                  SizedBox(height: 20),
                  CustomButton(color: AppColors.pink, action: () => _viewModel.startConnection(), text: "Connect to Sensor"),
                  SizedBox(height: 30,),
                  CustomButton(color: AppColors.red, action: (){}, text: "Diagnose",width: MediaQuery.of(context).size.width / 2,),
                  SizedBox(height: 50,),
                  Text("Please: Open the Bluetooth before Connecting to the sensor",textAlign: TextAlign.center,)
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTile(String label, String value, String unit) {
    return ListTile(
      title: Text(label),
      trailing: Text("$value $unit",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)
      ),
    );
  }
}