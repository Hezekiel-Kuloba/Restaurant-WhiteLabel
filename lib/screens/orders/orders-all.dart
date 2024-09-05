// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_app/utilis/orders.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';
import 'dart:convert';
import '../../models/order.dart'; // Ensure you have a order model
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  List<Orders> orders = [];
  final orderService = OrdersService();
  Future<void> _getOrders() async {
    orders = await orderService.getOrders();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getOrders();
  }

  void _confirmDeleteOrder(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete order'),
          content: const Text('Are you sure you want to delete this order?'),
          actions: [
            TextButton(
              onPressed: () async {
                await orderService.deleteOrder(orderId).then((_) {
                  // Refresh the order list
                  _getOrders();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('order deleted successfully!')),
                  );
                }).catchError((e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Error 2: $e',
                    ),
                    duration: const Duration(seconds: 30),
                  ));
                });
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    String? role = authState.role;
    return Scaffold(
      appBar: AppBar(
        title: const Text('orders'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.add),
        //     onPressed: _showAddorderDialog, // Show add order dialog when pressed
        //   ),
        // ],
      ),
      body: role == 'admin'
          ? ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  // Optional: Wrap in a Card for better UI
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display the basic order information
                        Text(
                          'Customer: ${order.firstName}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  Colors.black), // Change text color to black
                        ),
                        Text(
                          'Specific Instructions: ${order.specificinstructions ?? "None"}',
                          style: const TextStyle(
                              color:
                                  Colors.black), // Change text color to black
                        ),
                        const SizedBox(height: 8), // Add some space

                        // Display the items in the order
                        if (order.items != null && order.items!.isNotEmpty) ...[
                          Column(
                            children: [
                              for (var item in order.items!) ...[
                                Text(
                                  '- ${item.stewname ?? "N/A"}',
                                  style: const TextStyle(
                                      color: Colors
                                          .black), // Change text color to black
                                ),
                                const Divider(),
                              ],
                            ],
                          ),
                        ],

                        // Action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _confirmDeleteOrder(context, '${order.id}'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  // Optional: Wrap in a Card for better UI
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display the basic order information
                        Text(
                          'Customer: ${order.firstName}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  Colors.black), // Change text color to black
                        ),
                        Text(
                          'Specific Instructions: ${order.specificinstructions ?? "None"}',
                          style: const TextStyle(
                              color:
                                  Colors.black), // Change text color to black
                        ),
                        const SizedBox(height: 8), // Add some space

                        // Display the items in the order
                        if (order.items != null && order.items!.isNotEmpty) ...[
                          const Text('Order Items:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors
                                      .black)), // Change text color to black
                          Column(
                            children: [
                              for (var item in order.items!) ...[
                                Text(
                                  '- ${item.stewname ?? "N/A"}',
                                  style: const TextStyle(
                                      color: Colors
                                          .black), // Change text color to black
                                ),
                                const Divider(),
                              ],
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
