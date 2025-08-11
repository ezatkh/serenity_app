import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/features/cases/cases_ui/widgets/caseItem_skeleton.dart';
import 'package:serenity_app/features/cases/cases_ui/widgets/case_item_widget.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../core/services/local/LocalizationService.dart';
import '../../../data/Models/cases_model.dart';
import '../../dashboard/dashboard_viewmodel/dashboard_viewmodel.dart';
import '../cases_viewmodel/cases_viewmodel.dart';

class CasesUI extends StatefulWidget {
  final Function(CaseModel)? onCaseSelected;

  const CasesUI({Key? key, this.onCaseSelected}) : super(key: key);

  @override
  State<CasesUI> createState() => _CasesUIState();
}

class _CasesUIState extends State<CasesUI> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final casesVM = Provider.of<CasesViewModel>(context, listen: false);
      if (!casesVM.isLoading && casesVM.cases.isEmpty) {
        casesVM.fetchCases(context);
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
            appLocalization.getLocalizedString("cases"),
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
                    style: TextStyle(fontSize: 16 * scale),
                  ),
                );
              }else {
                return RefreshIndicator(
                  onRefresh: () async {
                    final vm = Provider.of<CasesViewModel>(context, listen: false);
                    vm.resetFetched();
                    await vm.fetchCases(context);
                  },
                  child: ListView.builder(
                    itemCount: casesVM.cases.length,
                    itemBuilder: (context, index) {
                      final caseItem = casesVM.cases[index];
                      return CaseItemWidget(
                        caseItem: caseItem,
                        scale: scale,
                        onTap: () {
                          if (widget.onCaseSelected != null) {
                            widget.onCaseSelected!(caseItem);  // <-- call callback
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