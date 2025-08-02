import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/core/constants/app_colors.dart';
import 'package:serenity_app/data/Models/cases_model.dart';

import '../../../../core/services/local/LocalizationService.dart';
import '../../../dashboard/dashboard_viewmodel/dashboard_viewmodel.dart';
import '../../cases_viewmodel/cases_viewmodel.dart';
import 'caseItem_skeleton.dart';
import 'expandable_text.dart';
import 'label_value_column.dart';

class CaseItemDetailWidget extends StatefulWidget {
  final CaseModel caseItem;
  final double scale;
  final VoidCallback? onTap;

  const CaseItemDetailWidget({
    Key? key,
    required this.caseItem,
    required this.scale,
    this.onTap,
  }) : super(key: key);

  @override
  State<CaseItemDetailWidget> createState() => _CaseItemDetailWidgetState();
}

class _CaseItemDetailWidgetState extends State<CaseItemDetailWidget> {
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
        title: Text(
          '${appLocalization.getLocalizedString("case")} #${widget.caseItem.number}',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20 * widget.scale,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () {
            dashboardVM.setCurrentIndex(4);
          },
        ),
        iconTheme: const IconThemeData(
          color: AppColors.black,
        ),
        elevation: 0,
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Consumer<CasesViewModel>(
          builder: (context, casesVM, child) {
            if (casesVM.isLoading) {
              return ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => const CaseItemSkeleton(),
              );
            } else if (casesVM.cases.isEmpty) {
              return Center(
                child: Text(
                  appLocalization.getLocalizedString("no_cases_found"),
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
                        widget.caseItem.name ?? '',
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
                            value: widget.caseItem.status ?? '',
                            labelStyle: labelStyle,
                            valueStyle: valueStyle.copyWith(
                              color: AppColors.primaryBoldColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          LabelValueColumn(
                            label: appLocalization.getLocalizedString('owner'),
                            value: widget.caseItem.createdByName ?? '',
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
                            label: appLocalization.getLocalizedString('type'),
                            value: widget.caseItem.type ?? '',
                            labelStyle: labelStyle,
                            valueStyle: valueStyle,
                          ),
                          const SizedBox(width: 10),
                          LabelValueColumn(
                            label: appLocalization.getLocalizedString('subtype'),
                            value: widget.caseItem.category ?? '',
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
                        text: widget.caseItem.description ?? '',
                        expanded: _descExpanded,
                        onToggle: () => setState(() => _descExpanded = !_descExpanded),
                        textStyle: valueStyle,
                        seeMoreStyle: seeMoreStyle,
                      ),
                      const SizedBox(height: 32),

                      // Resolution title
                      Text(
                        appLocalization.getLocalizedString('resolution'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18 * widget.scale,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Resolution and closing date row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          LabelValueColumn(
                            label: appLocalization.getLocalizedString('resolution'),
                            value: widget.caseItem.resolution ?? '',
                            labelStyle: labelStyle,
                            valueStyle: valueStyle,
                          ),
                          const SizedBox(width: 40),
                          LabelValueColumn(
                            label: appLocalization.getLocalizedString('closingDate'),
                            value: widget.caseItem.closingDate ?? '',
                            labelStyle: labelStyle,
                            valueStyle: valueStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Resolution Description with See More
                      Text(
                        appLocalization.getLocalizedString('resolutionDescription'),
                        style: labelStyle,
                      ),
                      const SizedBox(height: 6),
                      ExpandableText(
                        text: widget.caseItem.resolutionDesc ?? '',
                        expanded: _resDescExpanded,
                        onToggle: () => setState(() => _resDescExpanded = !_resDescExpanded),
                        textStyle: valueStyle,
                        seeMoreStyle: seeMoreStyle,
                      ),
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

