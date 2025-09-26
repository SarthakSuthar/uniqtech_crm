import 'package:crm/screen/contacts/ui/add_customer_contact.dart';
import 'package:crm/screen/dashboard/ui/dashboard_screen.dart';
import 'package:crm/screen/contacts/ui/add_contact.dart';
import 'package:crm/screen/contacts/ui/contact_list.dart';
import 'package:crm/screen/inquiry/ui/add_inquiry.dart';
import 'package:crm/screen/inquiry/ui/inquiry_followup.dart';
import 'package:crm/screen/inquiry/ui/inquiry_list.dart';
import 'package:crm/screen/login/ui/forgot_password.dart';
import 'package:crm/screen/login/ui/login_screen.dart';
import 'package:crm/screen/orders/ui/add_order.dart';
import 'package:crm/screen/orders/ui/order_list.dart';
import 'package:crm/screen/quotes/ui/add_quotes.dart';
import 'package:crm/screen/quotes/ui/quote_list.dart';
import 'package:crm/screen/quotes/ui/quotes_followup.dart';
import 'package:crm/screen/report/ui/reports.dart';
import 'package:crm/screen/tasks/ui/add_task.dart';
import 'package:crm/screen/tasks/ui/tasks_list.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const forgotPassword = '/forgot_password';
  static const dashboard = '/dashboard';
  static const contactList = '/contact';
  static const addContact = '/add_contact';
  static const addContactCustomer = '/add_contact_customer';
  static const editContact = '/edit_contact';
  static const inquiry = '/inquiry';
  static const addInquiry = '/add_inquiry';
  static const inquiryFollowup = '/inquiry_followup';
  static const quote = '/quote';
  static const addQuote = '/add_quote';
  static const quotesFollowup = '/quotes_followup';
  static const order = '/order';
  static const addOrder = '/add_order';
  static const tasks = '/tasks';
  static const addTask = '/add_task';
  static const report = '/report';

  static final routes = [
    // GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: forgotPassword, page: () => const ForgotPassword()),
    GetPage(name: dashboard, page: () => const DashboardScreen()),
    GetPage(name: contactList, page: () => const ContactList()),
    GetPage(
      name: AppRoutes.addContact,
      page: () {
        if (Get.arguments == null) {
          return AddContactScreen(isEdit: false, uid: '');
        }
        final args = Get.arguments as Map<String, dynamic>;
        return AddContactScreen(isEdit: args['isEdit'], uid: args['uid']);
      },
    ),
    GetPage(
      name: addContactCustomer,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return AddCustomerContactScreen(
          isEdit: args['isEdit'],
          uid: args['uid'],
        );
      },
    ),
    // GetPage(name: editContact, page: () => const EditContact()),
    GetPage(name: inquiry, page: () => InquiryList()),
    GetPage(
      name: addInquiry,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return AddInquiryScreen(no: args['no'], isEdit: args['isEdit']);
      },
    ),
    GetPage(
      name: inquiryFollowup,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return InquiryFollowup(inquiryId: args['inquiryId']);
      },
    ),
    // GetPage(name: addContactCustomer, page: () => AddCustomerContactScreen()),
    GetPage(name: quote, page: () => const QuoteList()),
    GetPage(
      name: addQuote,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return AddQuotes(no: args['no'], isEdit: args['isEdit']);
      },
    ),
    GetPage(name: quotesFollowup, page: () => QuotesFollowup()),
    GetPage(name: order, page: () => const OrderList()),
    GetPage(name: addOrder, page: () => const AddOrder()),
    GetPage(name: tasks, page: () => const TasksList()),
    GetPage(
      name: addTask,
      page: () => AddTask(isEdit: Get.arguments ?? false),
    ),
    GetPage(name: report, page: () => const Reports()),
  ];
}
