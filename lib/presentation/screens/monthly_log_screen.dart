import 'package:flutter/material.dart';
import 'package:carvita/services/car_fund_service.dart';

class MonthlyLogScreen extends StatefulWidget {
  const MonthlyLogScreen({super.key});

  @override
  State<MonthlyLogScreen> createState() => _MonthlyLogScreenState();
}

class _MonthlyLogScreenState extends State<MonthlyLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _odoController = TextEditingController();
  String _selectedMonth = 'June 2026';
  double _milesDriven = 0;
  double _reimbursement = 0;
  bool _showResults = false;

  final List<String> _months = [
    'January 2026', 'February 2026', 'March 2026', 'April 2026',
    'May 2026', 'June 2026', 'July 2026', 'August 2026',
    'September 2026', 'October 2026', 'November 2026', 'December 2026',
  ];

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final currentOdo = double.tryParse(_odoController.text) ?? 0;
      _milesDriven = 1200; // TODO: we'll improve this later
      _reimbursement = _milesDriven * 0.725;
      
      setState(() {
        _showResults = true;
      });
    }
  }

  Future<void> _addToCarFund() async {
    await CarFundService.addToFund(_reimbursement);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added \$${_reimbursement.toStringAsFixed(2)} to Car Fund!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Reimbursement')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Log this month's odometer reading",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              DropdownButtonFormField<String>(
                value: _selectedMonth,
                decoration: const InputDecoration(
                  labelText: 'Month',
                  border: OutlineInputBorder(),
                ),
                items: _months.map((month) => DropdownMenuItem(value: month, child: Text(month))).toList(),
                onChanged: (value) => setState(() => _selectedMonth = value!),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _odoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Current Odometer Reading',
                  border: OutlineInputBorder(),
                  suffixText: 'miles',
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter odometer reading' : null,
              ),
              const SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                child: const Text('Calculate Reimbursement'),
              ),
              
              if (_showResults) ...[
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Month: $_selectedMonth'),
                        Text('Miles driven: ${_milesDriven.toStringAsFixed(0)}'),
                        Text('Reimbursement: \$${_reimbursement.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addToCarFund,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size.fromHeight(50)),
                  child: const Text('Add to Car Fund'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
