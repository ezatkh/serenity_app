import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/core/constants/app_colors.dart';
import 'package:serenity_app/data/Models/appointments_model.dart';

import '../../../../core/services/local/LocalizationService.dart';
import '../../../dashboard/dashboard_viewmodel/dashboard_viewmodel.dart';
import '../../../../widgets/expandable_text.dart';
import '../../../../widgets/label_value_column.dart';
import '../../appointment_viewmodel/appointments_viewmodel.dart';
import 'appointment_skeleton.dart';

class AppointmentItemDetailWidget extends StatefulWidget {
  final AppointmentModel appointmentItem;
  final double scale;
  final VoidCallback? onTap;

  const AppointmentItemDetailWidget({
    Key? key,
    required this.appointmentItem,
    required this.scale,
    this.onTap,
  }) : super(key: key);

  @override
  State<AppointmentItemDetailWidget> createState() => _AppointmentItemDetailWidgetState();
}

class _AppointmentItemDetailWidgetState extends State<AppointmentItemDetailWidget> {
  bool _descExpanded = false;
  bool _resDescExpanded = false;

  @override
  Widget build(BuildContext context) {
    var appLocalization = Provider.of<LocalizationService>(context, listen: false);
    final dashboardVM = Provider.of<DashboardViewModel>(context, listen: false);


    final labelStyle = TextStyle(
      color: AppColors.grey,
      fontWeight: FontWeight.w400,
      fontSize: 11 * widget.scale,
    );

    final valueStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14 * widget.scale,
      color: Colors.black87,
    );

    final seeMoreStyle = TextStyle(
      color: AppColors.secondaryColor,
      fontWeight: FontWeight.w500,
      fontSize: 13 * widget.scale,
    );

    return  Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: Text('${widget.appointmentItem.name}',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20 * widget.scale,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () {
            dashboardVM.setCurrentIndex(9);
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
                child: Text(
                  appLocalization.getLocalizedString("no_appointments_found"),
                  style: TextStyle(fontSize: 16 * widget.scale),
                ),
              );
            }else {
              return
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 3,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name (Title)
                      Text(
                        widget.appointmentItem.name ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16 * widget.scale,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          LabelValueColumn(
                            label: appLocalization.getLocalizedString('status'),
                            value: widget.appointmentItem.status ?? '',
                            labelStyle: labelStyle,
                            valueStyle: valueStyle.copyWith(
                              color: AppColors.primaryBoldColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          LabelValueColumn(
                            label: appLocalization.getLocalizedString('organizer'),
                            value: widget.appointmentItem.assignedUserName ?? '',
                            labelStyle: labelStyle,
                            valueStyle: valueStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          LabelValueColumn(
                            label: appLocalization.getLocalizedString('dateStart'),
                             value: widget.appointmentItem.dateStart ?? '',
                            labelStyle: labelStyle,
                            valueStyle: valueStyle,
                          ),
                          const SizedBox(width: 10),
                          LabelValueColumn(
                            label: appLocalization.getLocalizedString('dateEnd'),
                             value: widget.appointmentItem.dateEnd ?? '',
                            labelStyle: labelStyle,
                            valueStyle: valueStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          LabelValueColumn(
                            label: appLocalization.getLocalizedString('duration'),
                            value: widget.appointmentItem.duration ?? '',
                            labelStyle: labelStyle,
                            valueStyle: valueStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        appLocalization.getLocalizedString('description'),
                        style: labelStyle,
                      ),
                      const SizedBox(height: 6),
                      ExpandableText(
                        text: widget.appointmentItem.description ?? '',
                        expanded: _descExpanded,
                        onToggle: () => setState(() => _descExpanded = !_descExpanded),
                        textStyle: valueStyle,
                        seeMoreStyle: seeMoreStyle,
                      ),
                      const SizedBox(height: 32),
                    ],
                ),
                  ),
              );
              ;
            }
          },
        ),
      ),
    );
  }
}

