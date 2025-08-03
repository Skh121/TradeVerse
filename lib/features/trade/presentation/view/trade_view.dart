// lib/features/trade/presentation/pages/trade_logging_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tradeverse/features/trade/domain/entity/trade_entity.dart';
import 'package:tradeverse/features/trade/presentation/view_model/trade_event.dart';
import 'package:tradeverse/features/trade/presentation/view_model/trade_state.dart';
import 'package:tradeverse/features/trade/presentation/view_model/trade_view_model.dart'; // For date formatting

class TradeView extends StatefulWidget {
  const TradeView({super.key});

  @override
  State<TradeView> createState() => _TradeViewState();
}

class _TradeViewState extends State<TradeView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _symbolController = TextEditingController();
  final TextEditingController _entryPriceController = TextEditingController();
  final TextEditingController _exitPriceController = TextEditingController();
  final TextEditingController _positionSizeController = TextEditingController();
  final TextEditingController _stopLossController = TextEditingController();
  final TextEditingController _takeProfitController = TextEditingController();
  final TextEditingController _feesController = TextEditingController();
  final TextEditingController _entryDateController = TextEditingController();
  final TextEditingController _exitDateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String? _selectedAssetClass;
  String _selectedTradeDirection = 'long'; // Default to Long
  List<String> _selectedTags = [];
  File? _chartScreenshotFile; // For new/updated file upload
  String? _currentChartScreenshotUrl; // For displaying existing URL

  TradeEntity? _editingTrade; // Holds the trade being edited

  final List<String> _assetClasses = [
    'stocks',
    'crypto',
    'forex',
    'commodities',
  ];
  final List<String> _tradeTags = [
    'Breakout',
    'Reversal',
    'Pullback',
    'News',
    'Earnings',
    'Technical',
    'Fundamental',
  ];

  @override
  void initState() {
    super.initState();
    // Fetch all trades when the page initializes
    context.read<TradeViewModel>().add(const FetchAllTrades());
  }

  @override
  void dispose() {
    _symbolController.dispose();
    _entryPriceController.dispose();
    _exitPriceController.dispose();
    _positionSizeController.dispose();
    _stopLossController.dispose();
    _takeProfitController.dispose();
    _feesController.dispose();
    _entryDateController.dispose();
    _exitDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  /// Handles picking a date.
  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  /// Handles picking a chart screenshot.
  Future<void> _pickChartScreenshot() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _chartScreenshotFile = File(image.path);
        _currentChartScreenshotUrl =
            null; // Clear existing URL if new file is picked
      });
    }
  }

  /// Clears the chart screenshot.
  void _clearChartScreenshot() {
    setState(() {
      _chartScreenshotFile = null;
      _currentChartScreenshotUrl = ''; // Mark for clearing on backend
    });
  }

  /// Clears the form and resets to create mode.
  void _clearForm() {
    setState(() {
      _editingTrade = null;
      _symbolController.clear();
      _entryPriceController.clear();
      _exitPriceController.clear();
      _positionSizeController.clear();
      _stopLossController.clear();
      _takeProfitController.clear();
      _feesController.clear();
      _entryDateController.clear();
      _exitDateController.clear();
      _notesController.clear();
      _selectedAssetClass = null;
      _selectedTradeDirection = 'long';
      _selectedTags = [];
      _chartScreenshotFile = null;
      _currentChartScreenshotUrl = null;
      _formKey.currentState?.reset(); // Reset form validation
    });
  }

  /// Populates the form for editing an existing trade.
  void _editTrade(TradeEntity trade) {
    setState(() {
      _editingTrade = trade;
      _symbolController.text = trade.symbol;
      _entryPriceController.text = trade.entryPrice.toString();
      _exitPriceController.text = trade.exitPrice?.toString() ?? '';
      _positionSizeController.text = trade.positionSize.toString();
      _stopLossController.text = trade.stopLoss?.toString() ?? '';
      _takeProfitController.text = trade.takeProfit?.toString() ?? '';
      _feesController.text = trade.fees.toString();
      _entryDateController.text = DateFormat(
        'yyyy-MM-dd',
      ).format(trade.entryDate.toLocal());
      _exitDateController.text =
          trade.exitDate != null
              ? DateFormat('yyyy-MM-dd').format(
                trade.exitDate!.toLocal(),
              ) // Convert to local time
              : '';
      _notesController.text = trade.notes ?? '';
      _selectedAssetClass = trade.assetClass;
      _selectedTradeDirection = trade.tradeDirection;
      _selectedTags = List.from(trade.tags);
      _currentChartScreenshotUrl = trade.chartScreenshotUrl;
      _chartScreenshotFile = null; // No new file selected yet for edit
    });
  }

  /// Handles saving a new trade or updating an existing one.
  void _saveTrade() {
    if (_formKey.currentState!.validate()) {
      final String symbol = _symbolController.text;
      final String assetClass = _selectedAssetClass!;
      final String tradeDirection = _selectedTradeDirection;
      final DateTime entryDate = DateTime.parse(_entryDateController.text);
      final double entryPrice = double.parse(_entryPriceController.text);
      final int positionSize = int.parse(_positionSizeController.text);
      final double fees = double.parse(_feesController.text);
      final String? notes =
          _notesController.text.isEmpty ? null : _notesController.text;

      DateTime? exitDate;
      if (_exitDateController.text.isNotEmpty) {
        exitDate = DateTime.parse(_exitDateController.text);
      }
      double? exitPrice;
      if (_exitPriceController.text.isNotEmpty) {
        exitPrice = double.parse(_exitPriceController.text);
      }
      double? stopLoss;
      if (_stopLossController.text.isNotEmpty) {
        stopLoss = double.parse(_stopLossController.text);
      }
      double? takeProfit;
      if (_takeProfitController.text.isNotEmpty) {
        takeProfit = double.parse(_takeProfitController.text);
      }

      if (exitDate != null && entryDate.isAfter(exitDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exit date must be after entry date.')),
        );
        return;
      }

      if (_editingTrade == null) {
        // Create new trade
        context.read<TradeViewModel>().add(
          CreateTradeEvent(
            symbol: symbol,
            assetClass: assetClass,
            tradeDirection: tradeDirection,
            entryDate: entryDate,
            entryPrice: entryPrice,
            positionSize: positionSize,
            exitDate: exitDate,
            exitPrice: exitPrice,
            stopLoss: stopLoss,
            takeProfit: takeProfit,
            fees: fees,
            tags: _selectedTags,
            notes: notes,
            chartScreenshotFile: _chartScreenshotFile,
          ),
        );
      } else {
        // Update existing trade
        context.read<TradeViewModel>().add(
          UpdateTradeEvent(
            id: _editingTrade!.id,
            symbol: symbol,
            assetClass: assetClass,
            tradeDirection: tradeDirection,
            entryDate: entryDate,
            entryPrice: entryPrice,
            positionSize: positionSize,
            exitDate: exitDate,
            exitPrice: exitPrice,
            stopLoss: stopLoss,
            takeProfit: takeProfit,
            fees: fees,
            tags: _selectedTags,
            notes: notes,
            chartScreenshotFile: _chartScreenshotFile,
            clearChartScreenshot:
                _currentChartScreenshotUrl == '', // Pass true if cleared
          ),
        );
      }
      _clearForm(); // Clear form after saving
    }
  }

  /// Shows a confirmation dialog for deleting a trade.
  Future<void> _confirmDeleteTrade(String tradeId) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Trade',
            style: TextStyle(color: Colors.black),
          ),
          content: const Text(
            'Are you sure you want to delete this trade?',
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      context.read<TradeViewModel>().add(DeleteTradeEvent(id: tradeId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White theme
      appBar: AppBar(
        title: const Text(
          'Trade Logging',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocConsumer<TradeViewModel, TradeState>(
        listener: (context, state) {
          if (state is TradeOperationSuccess) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is TradeError) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          } else if (state is TradeLoading) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing trade...')),
            );
          }
        },
        builder: (context, state) {
          List<TradeEntity> trades = [];
          bool isLoading = false;

          if (state is TradesLoaded) {
            trades = state.paginatedTrades.trades;
          } else if (state is TradeLoading &&
              context.read<TradeViewModel>().state is TradesLoaded) {
            // Keep showing previous trades while new operation is loading
            trades =
                (context.read<TradeViewModel>().state as TradesLoaded)
                    .paginatedTrades
                    .trades;
            isLoading = true;
          } else if (state is TradeLoading) {
            isLoading = true;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Log New Trade Section
                Text(
                  _editingTrade == null ? '1. Log New Trade' : '1. Edit Trade',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Symbol / Ticker
                      TextFormField(
                        controller: _symbolController,
                        decoration: const InputDecoration(
                          labelText: 'Symbol/Ticker (e.g., AAPL, BTC/USD)',
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a symbol/ticker';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Asset Class
                      DropdownButtonFormField<String>(
                        value: _selectedAssetClass,
                        hint: const Text(
                          'Select asset class',
                          style: TextStyle(color: Colors.grey),
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Asset Class',
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                        items:
                            _assetClasses.map((String assetClass) {
                              return DropdownMenuItem<String>(
                                value: assetClass,
                                child: Text(
                                  assetClass[0].toUpperCase() +
                                      assetClass.substring(1),
                                ),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedAssetClass = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an asset class';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Trade Direction
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Trade Direction',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            ToggleButtons(
                              isSelected: [
                                _selectedTradeDirection == 'long',
                                _selectedTradeDirection == 'short',
                              ],
                              onPressed: (int index) {
                                setState(() {
                                  _selectedTradeDirection =
                                      index == 0 ? 'long' : 'short';
                                });
                              },
                              borderRadius: BorderRadius.circular(8),
                              selectedColor: Colors.white,
                              fillColor: Colors.blue,
                              borderColor: Colors.grey,
                              selectedBorderColor: Colors.blue,
                              children: const <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Text('Long'),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Text('Short'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Entry Price & Exit Price
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _entryPriceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Entry Price',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter entry price';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Valid number required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _exitPriceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Exit Price (Optional)',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
                              validator: (value) {
                                if (value != null &&
                                    value.isNotEmpty &&
                                    double.tryParse(value) == null) {
                                  return 'Valid number required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Position Size & Fees/Commission
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _positionSizeController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Position Size',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter position size';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Valid integer required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _feesController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Fees/Commission (Optional)',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
                              validator: (value) {
                                if (value != null &&
                                    value.isNotEmpty &&
                                    double.tryParse(value) == null) {
                                  return 'Valid number required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Stop Loss & Take Profit
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _stopLossController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Stop Loss (Optional)',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
                              validator: (value) {
                                if (value != null &&
                                    value.isNotEmpty &&
                                    double.tryParse(value) == null) {
                                  return 'Valid number required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _takeProfitController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Take Profit (Optional)',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
                              validator: (value) {
                                if (value != null &&
                                    value.isNotEmpty &&
                                    double.tryParse(value) == null) {
                                  return 'Valid number required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Entry Date & Exit Date
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _entryDateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Entry Date (mm/dd/yyyy)',
                                border: const OutlineInputBorder(),
                                labelStyle: const TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.calendar_today,
                                    color: Colors.grey,
                                  ),
                                  onPressed:
                                      () => _selectDate(
                                        context,
                                        _entryDateController,
                                      ),
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select entry date';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _exitDateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Exit Date (Optional)',
                                border: const OutlineInputBorder(),
                                labelStyle: const TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.calendar_today,
                                    color: Colors.grey,
                                  ),
                                  onPressed:
                                      () => _selectDate(
                                        context,
                                        _exitDateController,
                                      ),
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Trade Setup Tags
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Trade Setup Tags',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children:
                                  _tradeTags.map((tag) {
                                    final isSelected = _selectedTags.contains(
                                      tag,
                                    );
                                    return FilterChip(
                                      label: Text(tag),
                                      selected: isSelected,
                                      onSelected: (bool selected) {
                                        setState(() {
                                          if (selected) {
                                            _selectedTags.add(tag);
                                          } else {
                                            _selectedTags.remove(tag);
                                          }
                                        });
                                      },
                                      selectedColor: Colors.blue,
                                      checkmarkColor: Colors.white,
                                      labelStyle: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                      backgroundColor: Colors.grey[200],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                          color:
                                              isSelected
                                                  ? Colors.blue
                                                  : Colors.grey,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Trade Notes & Analysis
                      TextFormField(
                        controller: _notesController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Trade Notes & Analysis',
                          hintText:
                              'Describe your trade setup, reasoning, market conditions, emotions, and lessons learned...',
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 16),

                      // Chart Screenshot
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Chart Screenshot (Optional)',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[100],
                            ),
                            child: Column(
                              children: [
                                if (_chartScreenshotFile != null)
                                  Image.file(
                                    _chartScreenshotFile!,
                                    height: 150,
                                    fit: BoxFit.contain,
                                  )
                                else if (_currentChartScreenshotUrl != null &&
                                    _currentChartScreenshotUrl!.isNotEmpty)
                                  Image.network(
                                    _currentChartScreenshotUrl!,
                                    height: 150,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.image_not_supported,
                                              size: 100,
                                              color: Colors.grey,
                                            ),
                                  )
                                else
                                  Icon(
                                    Icons.cloud_upload,
                                    size: 80,
                                    color: Colors.grey[600],
                                  ),
                                const SizedBox(height: 16),
                                Text(
                                  _chartScreenshotFile != null
                                      ? _chartScreenshotFile!.path
                                          .split('/')
                                          .last
                                      : (_currentChartScreenshotUrl != null &&
                                              _currentChartScreenshotUrl!
                                                  .isNotEmpty
                                          ? 'Existing Screenshot'
                                          : 'Upload a file or drag and drop'),
                                  style: const TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'PNG, JPG, GIF up to 10MB',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: _pickChartScreenshot,
                                      icon: const Icon(
                                        Icons.photo_library,
                                        color: Colors.white,
                                      ),
                                      label: const Text(
                                        'Select Image',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    if (_chartScreenshotFile != null ||
                                        (_currentChartScreenshotUrl != null &&
                                            _currentChartScreenshotUrl!
                                                .isNotEmpty))
                                      ElevatedButton.icon(
                                        onPressed: _clearChartScreenshot,
                                        icon: const Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                        ),
                                        label: const Text(
                                          'Clear',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Save Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: isLoading ? null : _saveTrade,
                            icon:
                                isLoading
                                    ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Icon(
                                      _editingTrade == null
                                          ? Icons.save
                                          : Icons.update,
                                      color: Colors.white,
                                    ),
                            label: Text(
                              _editingTrade == null
                                  ? 'Save Trade'
                                  : 'Update Trade',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black, // Black button
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          if (_editingTrade != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: OutlinedButton(
                                onPressed: isLoading ? null : _clearForm,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.grey,
                                  side: const BorderSide(color: Colors.grey),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Cancel Edit'),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // 2. Trade Logging Overview Section
                Text(
                  '2. Trade Logging Overview',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 16),
                isLoading && trades.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : trades.isEmpty
                    ? const Center(
                      child: Text(
                        'No trades logged yet.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: trades.length,
                      itemBuilder: (context, index) {
                        final trade = trades[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          color: const Color(
                            0xFFf9f9f8,
                          ), // Light card background
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Chart Screenshot Thumbnail
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                      child:
                                          trade.chartScreenshotUrl != null &&
                                                  trade
                                                      .chartScreenshotUrl!
                                                      .isNotEmpty
                                              ? Image.network(
                                                trade.chartScreenshotUrl!,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => const Icon(
                                                      Icons.broken_image,
                                                      size: 40,
                                                      color: Colors.grey,
                                                    ),
                                              )
                                              : Icon(
                                                Icons.image,
                                                size: 40,
                                                color: Colors.grey[600],
                                              ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            trade.symbol,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Direction: ${trade.tradeDirection[0].toUpperCase() + trade.tradeDirection.substring(1)}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  trade.tradeDirection == 'long'
                                                      ? Colors.green
                                                      : Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Entry Date: ${DateFormat('MMM dd, yyyy').format(trade.entryDate)}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            'P/L: \$${trade.pnl.toStringAsFixed(2)}', // Using computed PnL
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  trade.pnl >= 0
                                                      ? Colors.green
                                                      : Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          ),
                                          onPressed:
                                              isLoading
                                                  ? null
                                                  : () => _editTrade(trade),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed:
                                              isLoading
                                                  ? null
                                                  : () => _confirmDeleteTrade(
                                                    trade.id,
                                                  ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}
