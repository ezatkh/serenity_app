import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/features/appointments/appointment_ui/widgets/appointment_item_widget.dart';
import 'package:serenity_app/features/appointments/appointment_ui/widgets/appointment_skeleton.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../core/services/local/LocalizationService.dart';
import '../../../data/Models/appointments_model.dart';
import '../../dashboard/dashboard_viewmodel/dashboard_viewmodel.dart';
import '../appointment_viewmodel/appointments_viewmodel.dart';

class AppointmentsUI extends StatefulWidget {
  final Function(AppointmentModel)? onAppointmentSelected;

  const AppointmentsUI({Key? key, this.onAppointmentSelected}) : super(key: key);

  @override
  State<AppointmentsUI> createState() => _AppointmentsUIState();
}

class _AppointmentsUIState extends State<AppointmentsUI> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appointmentsVM = Provider.of<AppointmentsViewModel>(context, listen: false);
      if (!appointmentsVM.isLoading && appointmentsVM.appointments.isEmpty) {
        appointmentsVM.fetchAppointments(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.shortestSide / 375).clamp(1.0, 1.3);
    var appLocalization = Provider.of<LocalizationService>(context, listen: false);
    final dashboardVM = Provider.of<DashboardViewModel>(context, listen: false);

    return  WillPopScope(
      onWillPop: () async {
        dashboardVM.setCurrentIndex(0);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          title: Text(
            appLocalization.getLocalizedString("appointments"),
            style: TextStyle(
                color: Colors.black,
                fontSize: 20 * scale,
                fontWeight: FontWeight.w500
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.black),
            onPressed: () {
              dashboardVM.setCurrentIndex(0);
            },
          ),
          iconTheme: const IconThemeData(
            color: AppColors.black,
          ),
          elevation: 0,
        ),
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Consumer<AppointmentsViewModel>(
            builder: (context, appointmentsVM, child) {
              if (appointmentsVM.isLoading) {
                return ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) => const AppointmentItemSkeleton(),
                );
              } else if (appointmentsVM.appointments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/empty_box.png',
                        width: 120 * scale,
                        height: 120 * scale,
                        fit: BoxFit.contain,
                        color: AppColors.grey,
                      ),
                      SizedBox(height: 16 * scale), // spacing adjusts with scale
                      Text(
                        appLocalization.getLocalizedString("no_appointments_found"),
                        style: TextStyle(fontSize: 16 * scale,color: AppColors.grey),
                      ),
                    ],
                  ),
                );

              }else {
                return RefreshIndicator(
                  onRefresh: () async {
                    final vm = Provider.of<AppointmentsViewModel>(context, listen: false);
                    vm.resetFetched();
                    await vm.fetchAppointments(context);
                  },
                  child: ListView.builder(
                    itemCount: appointmentsVM.appointments.length,
                    itemBuilder: (context, index) {
                      final appointmentItem = appointmentsVM.appointments[index];
                      return AppointmentItemWidget(
                        appointmentItem: appointmentItem,
                        scale: scale,
                        onTap: () {
                          if (widget.onAppointmentSelected != null) {
                            widget.onAppointmentSelected!(appointmentItem);  // <-- call callback
                          }
                        },
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}