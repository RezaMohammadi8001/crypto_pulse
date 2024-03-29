import 'package:cypto_pulse/bloc/home/home_bloc.dart';
import 'package:cypto_pulse/bloc/home/home_state.dart';
import 'package:cypto_pulse/theme_switcher.dart';
import 'package:cypto_pulse/widgets/asset_badge_widget.dart';
import 'package:cypto_pulse/widgets/coin_info_item_widget.dart';
import 'package:cypto_pulse/widgets/credit_card_widget.dart';
import 'package:cypto_pulse/widgets/rate_limiting_error_widget.dart';
import 'package:cypto_pulse/widgets/shimmer_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeService>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Container(),
        flexibleSpace: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.h),
          child: Row(
            children: [
              Image.asset(
                'assets/images/security-card.png',
              ),
              const SizedBox(width: 5),
              const Text(
                'Crypto Pulse',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Provider.of<ThemeService>(context, listen: false)
                      .switchTheme();
                },
                child: Switch(
                  trackColor: Theme.of(context).brightness == Brightness.dark
                      ? const MaterialStatePropertyAll(Colors.white)
                      : null,
                  trackOutlineColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? const MaterialStatePropertyAll(Colors.grey)
                          : null,
                  value: themeProvider.isDarkMode,
                  onChanged: (_) {
                    themeProvider.switchTheme();
                  },
                ),
              )
            ],
          ),
        ),
      ),
      body: BlocBuilder<CoinBloc, CoinState>(
        builder: (context, state) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 19.w),
                  child: _getAllAssetWidgets(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 23.0.h,
                    left: 21.0.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: double.infinity,
                      ),
                      Text(
                        '\$21,271.00',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        '+173% all time',
                        style: TextStyle(
                          color: Color(0xFF03B78C),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
                  child: const CreditCard(),
                ),
              ),
              SliverAppBar(
                pinned: true,
                elevation: 0,
                toolbarHeight: 35.h,
                flexibleSpace: Padding(
                  padding: EdgeInsets.only(left: 21.w, right: 20.w),
                  child: Row(
                    children: [
                      Text(
                        'Crypto Assets',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.add,
                        size: 35,
                      ),
                    ],
                  ),
                ),
              ),
              if (state is CoinLoadingState) ...[
                SliverList.builder(
                  itemBuilder: (context, index) => const ShimmerCard(),
                ),
              ],
              if (state is CoinResponseState) ...[
                state.coinList.fold(
                  (l) {
                    if (l ==
                        'The request returned an invalid status code of 429.') {
                      return const SliverToBoxAdapter(
                        child: RateLimitingError(),
                      );
                    } else {
                      return const SliverToBoxAdapter();
                    }
                  },
                  (r) => CoinInfoItem(
                    coinList: r,
                    length: r.length - 85,
                  ),
                )
              ],
              SliverPadding(
                padding: EdgeInsets.only(bottom: 45.w),
              ),
            ],
          );
        },
      ),
    );
  }

  Padding _getAllAssetWidgets() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
      child: Row(
        children: [
          const AssetBadgeWidget(symbol: 'BTC: 32%', hexColor: 0xffFF8E25),
          SizedBox(width: 11.w),
          const AssetBadgeWidget(symbol: 'ETH: 26%', hexColor: 0xff707D91),
          SizedBox(width: 11.w),
          const AssetBadgeWidget(symbol: 'LTC: 19%', hexColor: 0xff5261EC),
        ],
      ),
    );
  }
}
