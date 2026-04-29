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
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  final ScrollController _scrollController = ScrollController();
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
    _scrollController.dispose();
    _bgAnimationController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutQuart,
    );
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
                controller: _scrollController,
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
                    _buildFooter()
                        .animate()
                        .fadeIn(duration: 800.ms, delay: 1000.ms),
                    SizedBox(height: 4.h),
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          _buildAppLogo(),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF06B6D4), Color(0xFF10B981)],
                  ).createShader(bounds),
                  child: Text(
                    'BalanceWave',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: Colors.white,
                    ),
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .shimmer(duration: 3000.ms, color: Colors.white.withValues(alpha: 0.15)),
                SizedBox(height: 0.3.h),
                Text(
                  'Smart Tax Calculator',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 11.sp,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          _buildPortfolioButton(),
        ],
      ),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366F1), Color(0xFF06B6D4)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Icon(LucideIcons.waves, color: Colors.white, size: 24),
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
        .scaleXY(begin: 1, end: 1.05, duration: 2000.ms, curve: Curves.easeInOut);
  }

  Widget _buildPortfolioButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _launchUrl('https://farmanullah1.github.io/My-Portfolio/'),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.08),
                Colors.white.withValues(alpha: 0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.briefcase, color: Colors.white70, size: 15.sp),
              SizedBox(width: 1.5.w),
              Text(
                'Portfolio',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 1.w),
              Icon(LucideIcons.external_link, color: Colors.white30, size: 11.sp),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeToggle(CalculatorState state, CalculatorNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
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
                helperText: 'after 15% WHT deduction',
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
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  padding: EdgeInsets.zero,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF06B6D4)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 7.h,
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
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [
                                  Theme.of(context).primaryColor,
                                  Colors.tealAccent,
                                ],
                              ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
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
                'WHT (15%):',
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

  Widget _buildFooter() {
    return Column(
      children: [
        const Divider(color: Colors.white10),
        SizedBox(height: 4.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF06B6D4)],
                          ),
                        ),
                        child: const Center(
                          child: Icon(LucideIcons.waves, color: Colors.white, size: 16),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF06B6D4)],
                        ).createShader(bounds),
                        child: Text(
                          'BalanceWave',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Your smart & reliable mobile balance tax calculator for Pakistan. Built with precision for the 2026 tax regulations.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 13.sp,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Wrap(
                    spacing: 3.w,
                    runSpacing: 2.h,
                    children: [
                      _buildFooterSocialIcon(_buildBrandIcon('github'), 'https://github.com/farmanullah1'),
                      _buildFooterSocialIcon(_buildBrandIcon('linkedin'), 'https://linkedin.com/in/farmanullah1'),
                      _buildFooterSocialIcon(_buildBrandIcon('twitter'), 'https://twitter.com/farmanullah1'),
                      _buildFooterSocialIcon(const Icon(LucideIcons.mail, color: Colors.white70, size: 18), 'mailto:contact@farmanullah.com'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 4.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Resources',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                _buildFooterLink(LucideIcons.briefcase, 'Portfolio', 'https://farmanullah1.github.io/My-Portfolio/'),
                _buildFooterLink(LucideIcons.globe, 'API Docs', '#'),
                _buildFooterLink(LucideIcons.code, 'Open Source', '#'),
                SizedBox(height: 2.h),
                InkWell(
                  onTap: _scrollToTop,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.arrow_up, color: Colors.white, size: 16),
                        SizedBox(width: 2.w),
                        Text(
                          'Top',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(vertical: 3.h),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.white10)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '© ${DateTime.now().year} BalanceWave. Designed & Developed by Farmanullah Ansari.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      _buildBadge('v2.0.0'),
                      SizedBox(width: 2.w),
                      _buildBadge('Pakistan 2026'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooterSocialIcon(Widget icon, String url) {
    return InkWell(
      onTap: () => _launchUrl(url),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: icon,
      ),
    );
  }

  Widget _buildBrandIcon(String name, {double size = 20, Color color = Colors.white70}) {
    String svgData;
    switch (name) {
      case 'github':
        svgData =
            '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M15 22v-4a4.8 4.8 0 0 0-1-3.5c3 0 6-2 6-5.5.08-1.25-.27-2.48-1-3.5.28-1.15.28-2.35 0-3.5 0 0-1 0-3 1.5-2.64-.5-5.36-.5-8 0C6 2 5 2 5 2c-.3 1.15-.3 2.35 0 3.5A5.403 5.403 0 0 0 4 9c0 3.5 3 5.5 6 5.5-.39.49-.68 1.05-.85 1.65-.17.6-.22 1.23-.15 1.85v4"/><path d="M9 18c-4.51 2-5-2-7-2"/></svg>';
        break;
      case 'linkedin':
        svgData =
            '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z"/><rect width="4" height="12" x="2" y="9"/><circle cx="4" cy="4" r="2"/></svg>';
        break;
      case 'twitter':
        svgData =
            '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 4s-.7 2.1-2 3.4c1.6 10-9.4 17.3-18 11.6 2.2.1 4.4-.6 6-2C3 15.5.5 9.6 3 5c2.2 2.6 5.6 4.1 9 4-.9-4.2 4-6.6 7-3.8 1.1 0 3-1.2 3-1.2z"/></svg>';
        break;
      default:
        return Icon(LucideIcons.info, size: size, color: color);
    }
    return SvgPicture.string(
      svgData,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  Widget _buildFooterLink(IconData icon, String label, String url) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: InkWell(
        onTap: url == '#' ? null : () => _launchUrl(url),
        child: Row(
          children: [
            Icon(icon, color: Colors.white38, size: 14),
            SizedBox(width: 2.w),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white54,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
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
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                )
              : null,
          color: isActive ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
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
