import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/screen/masters/terms/model/terms_model.dart';
import 'package:crm/screen/masters/terms/repo/terms_repo.dart';
import 'package:get/get.dart';

class TermsController extends GetxController {
  RxList<TermsModel> allTerms = <TermsModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAllTerms();
  }

  /// Get all terms
  Future<void> getAllTerms() async {
    try {
      isLoading.value = true;
      List<TermsModel> terms = await TermsRepo.getAllTerms();
      allTerms.assignAll(terms);
    } catch (e) {
      showlog('Error fetching terms: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Insert a new term
  Future<void> insertTerms(TermsModel terms) async {
    try {
      isLoading.value = true;
      await TermsRepo.insertTerms(terms);
      getAllTerms(); // Refresh the list after insertion
    } catch (e) {
      showlog('Error inserting term: $e');
    } finally {
      isLoading.value = false;
    }
  }

  ///delete term
  Future<void> deleteTerm(int id) async {
    try {
      isLoading.value = true;
      await TermsRepo.deleteTerm(id);
      getAllTerms(); // Refresh the list after deletion
    } catch (e) {
      showlog('Error deleting term: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
