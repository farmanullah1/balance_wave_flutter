import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:math' as math;

import '../../../../shared/widgets/carrier_logo.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../core/constants/carriers.dart';
import '../../domain/carrier.dart';
import '../../domain/history_entry.dart';
import '../providers/calculator_provider.dart';

class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key});

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  late AnimationController _bgAnimationController;

  @override
  void initState() {
    super.initState();
    _bgAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _amountController.dispose();
    _bgAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(calculatorProvider);
    final notifier = ref.read(calculatorProvider.notifier);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // Handle back button if needed
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildBackground(),
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader()
                        .animate()
                        .fadeIn(duration: 800.ms)
                        .slideY(begin: -0.2, end: 0),
                    SizedBox(height: 4.h),
                    _buildModeToggle(state, notifier)
                        .animate()
                        .fadeIn(duration: 800.ms, delay: 200.ms)
                        .slideY(begin: 0.1, end: 0),
                    SizedBox(height: 3.h),
                    _buildForm(state, notifier)
                        .animate()
                        .fadeIn(duration: 800.ms, delay: 400.ms)
                        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),
                    SizedBox(height: 3.h),
                    _buildResultArea(state)
                        .animate()
                        .fadeIn(duration: 800.ms, delay: 600.ms),
                    SizedBox(height: 4.h),
                    if (state.history.isNotEmpty)
                      _buildHistorySection(state, notifier)
                          .animate()
                          .fadeIn(duration: 800.ms, delay: 800.ms),
                    SizedBox(height: 5.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _bgAnimationController,
      builder: (context, child) {
        return Stack(
          children: [
            Container(color: const Color(0xFF0F172A)),
            Positioned(
              top: -10.h,
              right: -10.w,
              child: _buildCircle(45.h, Colors.indigo.withValues(alpha: 0.2)),
            ),
            Positioned(
              bottom: -5.h,
              left: -10.w,
              child: _buildCircle(35.h, Colors.teal.withValues(alpha: 0.15)),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: WavePainter(_bgAnimationController.value),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(LucideIcons.waves, color: Colors.white, size: 28),
        ),
        SizedBox(width: 4.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BalanceWave',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22.sp),
            ),
            Text(
              'Smart Tax Calculator',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13.sp),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(LucideIcons.settings, color: Colors.white54),
        ),
      ],
    );
  }

  Widget _buildModeToggle(CalculatorState state, CalculatorNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeButton(
              title: 'Recharge → Balance',
              icon: LucideIcons.zap,
              isActive: state.mode == CalculationMode.forward,
              onTap: () => notifier.setMode(CalculationMode.forward),
            ),
          ),
          Expanded(
            child: _ModeButton(
              title: 'Target Balance',
              icon: LucideIcons.target,
              isActive: state.mode == CalculationMode.reverse,
              onTap: () => notifier.setMode(CalculationMode.reverse),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(CalculatorState state, CalculatorNotifier notifier) {
    return GlassCard(
      child: Padding(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel(LucideIcons.smartphone, 'Mobile Number', optional: true),
            SizedBox(height: 1.h),
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              style: TextStyle(fontSize: 16.sp),
              decoration: const InputDecoration(
                hintText: '03XXXXXXXXX',
                prefixIcon: Icon(LucideIcons.hash, size: 18),
              ),
              onChanged: notifier.setMobileNumber,
            ),
            SizedBox(height: 2.5.h),
            _buildFieldLabel(LucideIcons.factory, 'Carrier', optional: true),
            SizedBox(height: 1.h),
            _buildCarrierSelector(state, notifier),
            SizedBox(height: 2.5.h),
            _buildFieldLabel(
              LucideIcons.wallet,
              state.mode == CalculationMode.forward ? 'Recharge Amount' : 'Desired Balance',
            ),
            SizedBox(height: 1.h),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(fontSize: 16.sp),
              decoration: InputDecoration(
                hintText: state.mode == CalculationMode.forward ? '100' : '86.96',
                helperText: 'after 15% WHT on net balance',
                helperStyle: TextStyle(color: Colors.white24, fontSize: 11.sp),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Rs.', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 15.sp)),
                ),
              ),
              onChanged: notifier.setAmount,
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              height: 7.h,
              child: ElevatedButton(
                onPressed: state.isLoading
                    ? null
                    : () async {
                        if (await Vibration.hasVibrator()) {
                          Vibration.vibrate(duration: 50);
                        }
                        notifier.calculate();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 8,
                ),
                child: state.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(state.mode == CalculationMode.forward ? LucideIcons.zap : LucideIcons.target, size: 20),
                          SizedBox(width: 2.w),
                          Text(
                            state.mode == CalculationMode.forward ? 'Calculate Balance' : 'Calculate Recharge',
                            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(IconData icon, String label, {bool optional = false}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        SizedBox(width: 2.w),
        Text(label, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 14.sp)),
        if (optional) ...[
          SizedBox(width: 1.w),
          Text('(optional)', style: TextStyle(fontSize: 11.sp, color: Colors.white.withValues(alpha: 0.3))),
        ],
      ],
    );
  }

  Widget _buildCarrierSelector(CalculatorState state, CalculatorNotifier notifier) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Carrier>(
          value: state.selectedCarrier,
          hint: Text('Auto-detect or select…', style: TextStyle(color: Colors.white38, fontSize: 14.sp)),
          isExpanded: true,
          dropdownColor: const Color(0xFF1E293B),
          items: CarrierConstants.carriers.map((c) {
            return DropdownMenuItem<Carrier>(
              value: c,
              child: Row(
                children: [
                  CarrierLogo(carrier: c.name, size: 20),
                  SizedBox(width: 3.w),
                  Text(c.name, style: TextStyle(fontSize: 14.sp)),
                ],
              ),
            );
          }).toList(),
          onChanged: notifier.setSelectedCarrier,
        ),
      ),
    );
  }

  Widget _buildResultArea(CalculatorState state) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: state.result == null
          ? (state.isLoading ? _buildSkeleton() : _buildEmptyState())
          : _buildResultCard(state),
    );
  }

  Widget _buildEmptyState() {
    return GlassCard(
      height: 20.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.trending_up, size: 40, color: Colors.white24),
          SizedBox(height: 2.h),
          Text(
            'Fill in the form to calculate\nyour net balance',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return GlassCard(
      height: 20.h,
      child: Padding(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _skeletonBar(width: 30.w, height: 1.5.h),
            SizedBox(height: 1.5.h),
            _skeletonBar(width: 50.w, height: 4.h),
            const Spacer(),
            _skeletonBar(width: double.infinity, height: 6.h),
          ],
        ),
      ),
    );
  }

  Widget _skeletonBar({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildResultCard(CalculatorState state) {
    final result = state.result!;
    final isReverse = state.mode == CalculationMode.reverse;

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(-0.05),
      alignment: Alignment.center,
      child: GlassCard(
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isReverse ? 'Required Recharge Amount' : 'Net Balance After Tax',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13.sp),
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Rs. ${isReverse ? result['amount']!.toStringAsFixed(2) : result['net']!.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 28.sp,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      final text = isReverse
                          ? 'Required Recharge: Rs. ${result['amount']!.toStringAsFixed(2)}\nWHT: Rs. ${result['tax']!.toStringAsFixed(2)}\nDesired Balance: Rs. ${result['net']!.toStringAsFixed(2)}'
                          : 'Net Balance: Rs. ${result['net']!.toStringAsFixed(2)}\nWHT: Rs. ${result['tax']!.toStringAsFixed(2)}\nRecharge: Rs. ${result['amount']!.toStringAsFixed(2)}';
                      
                      Clipboard.setData(ClipboardData(text: text)).then((_) {
                        if (!mounted) return;
                        Vibration.vibrate(pattern: [0, 40, 20, 40]);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Copied to clipboard!'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      });
                    },
                    icon: const Icon(LucideIcons.copy, color: Colors.white54),
                  ),
                ],
              ),
              const Divider(height: 32, color: Colors.white10),
              _buildBreakdownRow(
                isReverse ? 'Desired Net Balance:' : 'Recharge Amount:',
                'Rs. ${isReverse ? result['net']!.toStringAsFixed(2) : result['amount']!.toStringAsFixed(2)}',
              ),
              SizedBox(height: 1.5.h),
              _buildBreakdownRow(
                'WHT (15% on net):',
                '${isReverse ? "+" : "−"} Rs. ${result['tax']!.toStringAsFixed(2)}',
                valueColor: isReverse ? Colors.orange : Colors.redAccent,
              ),
              if (state.selectedCarrier != null) ...[
                SizedBox(height: 1.5.h),
                _buildBreakdownRow(
                  'Carrier:',
                  state.selectedCarrier!.name,
                  valueWidget: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CarrierLogo(carrier: state.selectedCarrier!.name, size: 18),
                      SizedBox(width: 2.w),
                      Text(state.selectedCarrier!.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String value, {Color? valueColor, Widget? valueWidget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14.sp)),
        valueWidget ?? Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: valueColor ?? Colors.white, fontSize: 14.sp)),
      ],
    );
  }

  Widget _buildHistorySection(CalculatorState state, CalculatorNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'RECENT CALCULATIONS',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.white38,
              ),
            ),
            TextButton(
              onPressed: () => notifier.clearHistory(),
              child: Text('Clear history', style: TextStyle(color: Colors.redAccent, fontSize: 12.sp)),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),
        AnimationLimiter(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.history.length,
            separatorBuilder: (_, _) => SizedBox(height: 1.5.h),
            itemBuilder: (context, index) {
              final item = state.history[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: _buildHistoryItem(item),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(HistoryEntry item) {
    return GlassCard(
      borderRadius: 16,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        child: Row(
          children: [
            CarrierLogo(carrier: item.carrier, size: 32),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.mode == CalculationMode.reverse ? "🎯 Target" : "⚡ Forward"} · ${item.carrier}',
                    style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, color: Colors.white38),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Rs. ${item.amount.toStringAsFixed(2)} recharged',
                    style: TextStyle(fontSize: 13.sp, color: Colors.white70),
                  ),
                  Text(
                    DateFormat.jm().format(item.ts),
                    style: TextStyle(fontSize: 11.sp, color: Colors.white.withValues(alpha: 0.2)),
                  ),
                ],
              ),
            ),
            Text(
              'Rs. ${item.net.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _ModeButton({
    required this.title,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: isActive ? Colors.white : Colors.white38),
            SizedBox(width: 2.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Colors.white : Colors.white38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double progress;
  WavePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    final path = Path();
    final y = size.height * 0.8;
    
    path.moveTo(0, y);
    for (double x = 0; x <= size.width; x++) {
      path.lineTo(x, y + math.sin((x / size.width * 2 * math.pi) + (progress * 2 * math.pi)) * 2.h);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => oldDelegate.progress != progress;
}
