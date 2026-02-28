import 'package:car_e_rescue/core/constants/images/images_dir.dart';
import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/current_requests/view_model/client_current_request_view_model.dart';
import 'package:car_e_rescue/modules/widgets/custom_button.dart';
import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ClientCurrentRequestView extends StatefulWidget {
  const ClientCurrentRequestView({super.key});

  @override
  State<ClientCurrentRequestView> createState() => _CurrentRequestViewState();
}

class _CurrentRequestViewState extends State<ClientCurrentRequestView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClientCurrentRequestViewModel(),
      child: Consumer<ClientCurrentRequestViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            floatingActionButton: NavigateBackButton(),
            floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
            body: viewModel.isLoading
                ? Center(child: CircularProgressIndicator(color: AppColors.red,))
                : viewModel.currentRequest == null
                ? _buildEmptyState(context)
                : _buildRequestDetails(context,viewModel),
          );
        },
      ),
    );
  }
}

Widget _buildEmptyState(BuildContext context) {
  return Center(
    child: Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You have no current requests yet",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w400,
              color: AppColors.red,
            ),
          ),
          const SizedBox(height: 10),
          Image.asset(ImagesDir.noRequestsYet,width: 50,height: 50,),

          const SizedBox(height: 20),
          CustomButton(
            width: MediaQuery.of(context).size.width / 1.5,
            action: () => Navigator.of(
              context,
            ).pushNamed(PageRoutesName.createRequest),
            text: "Create a New Request",
            color: AppColors.red,
          ),
        ],
      ),
    ),
  );
}

Widget _buildRequestDetails(BuildContext context,ClientCurrentRequestViewModel viewModel) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text("Status: ${viewModel.currentRequest!.status}"),
          // Text("Mechanic: ${viewModel.currentRequest!.mechanicName ?? 'Finding Mechanic...'}"),
          // Text("Request ID: ${viewModel.currentRequest!.requestId ?? 'No Request ID'}"),
          Spacer(),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Bounceable(
                onTap: (){
                  ///TODO: view the mechanic current location
                    final request = viewModel.currentRequest!;

                    if (request.requestId != null && request.status == "Accepted") {
                      Navigator.pushNamed(
                        context,
                        PageRoutesName.mechanicLiveLocation,
                        arguments: request.requestId,
                      );
                    } else if (request.status != "Accepted") {
                      SnackbarService.showErrorNotification(
                          "Mechanic has not accepted the request yet. Current Status: ${request.status}"
                      );
                    } else {
                      SnackbarService.showErrorNotification("Error: Missing Request ID.");
                    }

                },
                child: Container(
                  width: double.infinity,
                  height: 200,
                  padding: EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Type: \n${viewModel.currentRequest!.type}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                                color: AppColors.white,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Status: \n${viewModel.currentRequest!.status}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      viewModel.currentRequest!.mechanicName == "----"
                          ? Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Waiting for Mechanic",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Lottie.asset(
                                    'assets/animations/circle-loader.json',
                                    height: 50,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            )
                          : Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 10,
                                children: [
                                  Text(
                                    "Mechanic: \n${viewModel.currentRequest!.mechanicName} has Accepted your request",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Poppins",
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Icon(Icons.check_circle,color: AppColors.green,size: 45,)
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: -40,
                left: MediaQuery.of(context).size.width / 2 - 60,
                child: Bounceable(
                  onTap: () async {
                    final confirm = await showEnsureDeletionDialog(context);
                    if (confirm == true) {
                      await viewModel.deleteCurrentRequest();
                      // if (success && context.mounted) {
                      //   3. Navigate back to Home or show success
                        // Navigator.of(context).pushReplacementNamed(PageRoutesName.clientHome);
                      // }
                    }
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(color: AppColors.white,
                      width: 3)
                    ),
                    child: Icon(Icons.delete_rounded, color: AppColors.white),
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          viewModel.currentRequest!.mechanicName == "----"
          ? const SizedBox()
          : Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.green.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                 Icon(
                  Icons.check_circle,
                  color: AppColors.white,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Click on the Request to\nTrack the Mechanic's Location.",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30,)

        ],
      ),
    ),
  );
}

Future<bool?> showEnsureDeletionDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true, // Prevents closing by tapping outside
    builder: (context) {
      var theme = Theme.of(context);
      return AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Confirm Deletion", style: theme.textTheme.titleMedium),
        content: Text(
          "Are you Sure you want to delete this request?",
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancel
            },
            child: Text("Cancel", style: theme.textTheme.bodyMedium),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () {
              Navigator.of(context).pop(true); // Confirm
            },
            child: Text(
              "Delete",
              style: theme.textTheme.bodyMedium!.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
        ],
      );
    },
  );
}
