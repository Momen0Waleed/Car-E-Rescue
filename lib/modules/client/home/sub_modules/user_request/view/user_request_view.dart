import 'package:car_e_rescue/core/constants/images/images_dir.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class UserRequestView extends StatefulWidget {
  const UserRequestView({super.key});

  @override
  State<UserRequestView> createState() => _UserRequestViewState();
}

class _UserRequestViewState extends State<UserRequestView> {
  @override
  Widget build(BuildContext context) {
  var theme = Theme.of(context);

    return Scaffold(
      appBar: defaultAppBar(title: "Request", context: context),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30,),
            ///Create
            Bounceable(
              onTap: (){
                Navigator.of(context).pushNamed(PageRoutesName.createRequest);
              },
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(18)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle,color: AppColors.white,size: 50,),
                    SizedBox(height: 16,),
                    Text("Create New Request",style: theme.textTheme.titleLarge!.copyWith(
                      color: AppColors.white,
                    ),),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30,),
            /// View Available Mechanics
            Bounceable(
              onTap: (){
                Navigator.of(context).pushNamed(PageRoutesName.availableMech);
              },
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                    color: AppColors.pink,
                    borderRadius: BorderRadius.circular(18)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(ImagesDir.mechanicIcon,width: 60,height: 60,color: AppColors.red,),
                    SizedBox(height: 12,),
                    Text("View Available Mechanics",style: theme.textTheme.bodyLarge!.copyWith(
                      color: AppColors.red,
                    ),),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            /// History
                Flexible(
                  flex: 3,
                  child: Bounceable(
                    onTap: (){
                      Navigator.of(context).pushNamed(PageRoutesName.requestHistory);
                    },
                    child: Container(
                      height: 125,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: AppColors.pink,
                          borderRadius: BorderRadius.circular(18)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.history,color: AppColors.red,size: 40,),
                          SizedBox(height: 8,),
                          Text("History",style: theme.textTheme.bodyLarge!.copyWith(
                            color: AppColors.red,
                          ),),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                /// Current Requests
                Flexible(
                  flex: 2,
                  child: Bounceable(
                    onTap: (){
                      Navigator.of(context).pushNamed(PageRoutesName.clientCurrentRequest);
                    },
                    child: Container(
                      height: 125,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: AppColors.pink,
                          borderRadius: BorderRadius.circular(18)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Icon(Icons.list,color: AppColors.red,size: 40,),
                          Image.asset(ImagesDir.currentRequestIcon,width: 50,height: 50),

                          Text("Current\nRequests",textAlign: TextAlign.center,style: theme.textTheme.bodyLarge!.copyWith(
                            color: AppColors.red,
                          ),),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
