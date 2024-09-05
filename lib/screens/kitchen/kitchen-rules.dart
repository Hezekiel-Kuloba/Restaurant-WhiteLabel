import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/utilis/rules.dart';
import '../../models/rule.dart';
import '../../providers/user_provider.dart'; // Import your user provider

class RulesScreen extends ConsumerStatefulWidget {
  const RulesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RulesScreenState();
}

class _RulesScreenState extends ConsumerState<RulesScreen> {
  List<Rules> _rules = [];
  final ruleService = RuleServices();

  Future<void> _getRules() async {
    _rules = await ruleService.getRules();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getRules();
  }

  void _confirmDeleteRule(BuildContext context, String ruleId, String token) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Rule'),
          content: const Text('Are you sure you want to delete this rule?'),
          actions: [
            TextButton(
              onPressed: () async {
                await ruleService.deleterule(ruleId, token).then((_) {
                  _getRules(); // Refresh the rule list
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Rule deleted successfully!')),
                  );
                }).catchError((e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Error: $e'),
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

  void _showAddRuleDialog(String token) {
    final TextEditingController ruleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Rule'),
          content: Form(
            child: TextFormField(
              controller: ruleController,
              decoration: const InputDecoration(labelText: 'Rule'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final String rule = ruleController.text;

                await ruleService.addRules(rule).then((_) {
                  _getRules(); // Refresh the rule list
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Rule added successfully!')),
                  );
                  Navigator.of(context).pop(); // Close the dialog
                }).catchError((e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Rule not added')));
                });
              },
              child: const Text('Add'),
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

  void _showEditRuleDialog(BuildContext context, String ruleId, String rules) {
    final TextEditingController ruleController = TextEditingController();
    ruleController.text = rules;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Rule'),
          content: Form(
            child: TextFormField(
              controller: ruleController,
              decoration: const InputDecoration(labelText: 'Edit Rule'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final String updatedRule = ruleController.text;

                await ruleService.updaterule(ruleId, updatedRule).then((_) {
                  _getRules(); // Refresh the rule list
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Rule updated successfully!')),
                  );
                  Navigator.of(context).pop(); // Close the dialog
                }).catchError((e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Error: $e'),
                    duration: const Duration(seconds: 30),
                  ));
                });
              },
              child: const Text('Update'),
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
    String? token = authState.token;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rules'),
        actions: role == 'admin'
            ? [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () =>
                      _showAddRuleDialog(token!), // Show add rule dialog
                ),
              ]
            : null, // Only show the add button if the user is an admin
      ),
      body: ListView.builder(
        itemCount: _rules.length,
        itemBuilder: (context, index) {
          final rule = _rules[index];
          return ListTile(
            title: Text('${rule.rule}'),
            trailing: role == 'admin'
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditRuleDialog(
                            context, '${rule.id}', '${rule.rule}'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            _confirmDeleteRule(context, '${rule.id}', token!),
                      ),
                    ],
                  )
                : null, // Only show the edit and delete buttons if the user is an admin
          );
        },
      ),
    );
  }
}
