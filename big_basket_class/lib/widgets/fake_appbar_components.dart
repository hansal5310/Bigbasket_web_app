import 'package:flutter/material.dart';

/// Fake/Example AppBar Components (Minimum 60 Height)
/// These are example components for screens NOT in the main 28 screens list

// 1. About Us Screen AppBar
Widget fakeAboutUsAppBar() {
  return AppBar(
    toolbarHeight: 60,
    title: Container(
      height: 60,
      alignment: Alignment.centerLeft,
      child: Text('About Us'),
    ),
    leading: Container(
      height: 60,
      width: 60,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {},
        constraints: BoxConstraints(minHeight: 60, minWidth: 60),
        iconSize: 28,
      ),
    ),
  );
}

// 2. Terms & Conditions Screen AppBar
Widget fakeTermsAppBar() {
  return AppBar(
    toolbarHeight: 60,
    title: Container(
      height: 60,
      alignment: Alignment.centerLeft,
      child: Text('Terms & Conditions'),
    ),
    leading: Container(
      height: 60,
      width: 60,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {},
        constraints: BoxConstraints(minHeight: 60, minWidth: 60),
        iconSize: 28,
      ),
    ),
    actions: [
      Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.info_outline),
          constraints: BoxConstraints(minHeight: 60, minWidth: 60),
          iconSize: 28,
        ),
      ),
    ],
  );
}

// 3. Privacy Policy Screen AppBar
Widget fakePrivacyAppBar() {
  return AppBar(
    toolbarHeight: 60,
    title: Container(
      height: 60,
      alignment: Alignment.centerLeft,
      child: Text('Privacy Policy'),
    ),
    leading: Container(
      height: 60,
      width: 60,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {},
        constraints: BoxConstraints(minHeight: 60, minWidth: 60),
        iconSize: 28,
      ),
    ),
  );
}

// 4. Feedback Screen AppBar
Widget fakeFeedbackAppBar() {
  return AppBar(
    toolbarHeight: 60,
    title: Container(
      height: 60,
      alignment: Alignment.centerLeft,
      child: Text('Feedback'),
    ),
    leading: Container(
      height: 60,
      width: 60,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {},
        constraints: BoxConstraints(minHeight: 60, minWidth: 60),
        iconSize: 28,
      ),
    ),
    actions: [
      Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.send),
          constraints: BoxConstraints(minHeight: 60, minWidth: 60),
          iconSize: 28,
        ),
      ),
    ],
  );
}

// 5. Contact Us Screen AppBar
Widget fakeContactUsAppBar() {
  return AppBar(
    toolbarHeight: 60,
    title: Container(
      height: 60,
      alignment: Alignment.centerLeft,
      child: Text('Contact Us'),
    ),
    leading: Container(
      height: 60,
      width: 60,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {},
        constraints: BoxConstraints(minHeight: 60, minWidth: 60),
        iconSize: 28,
      ),
    ),
    actions: [
      Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.phone),
          constraints: BoxConstraints(minHeight: 60, minWidth: 60),
          iconSize: 28,
        ),
      ),
      Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.email),
          constraints: BoxConstraints(minHeight: 60, minWidth: 60),
          iconSize: 28,
        ),
      ),
    ],
  );
}

// 6. FAQ Screen AppBar
Widget fakeFAQAppBar() {
  return AppBar(
    toolbarHeight: 60,
    title: Container(
      height: 60,
      alignment: Alignment.centerLeft,
      child: Text('Frequently Asked Questions'),
    ),
    leading: Container(
      height: 60,
      width: 60,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {},
        constraints: BoxConstraints(minHeight: 60, minWidth: 60),
        iconSize: 28,
      ),
    ),
    actions: [
      Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
          constraints: BoxConstraints(minHeight: 60, minWidth: 60),
          iconSize: 28,
        ),
      ),
    ],
  );
}

// 7. Reviews Screen AppBar
Widget fakeReviewsAppBar() {
  return AppBar(
    toolbarHeight: 60,
    title: Container(
      height: 60,
      alignment: Alignment.centerLeft,
      child: Text('Reviews & Ratings'),
    ),
    leading: Container(
      height: 60,
      width: 60,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {},
        constraints: BoxConstraints(minHeight: 60, minWidth: 60),
        iconSize: 28,
      ),
    ),
    actions: [
      Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.filter_list),
          constraints: BoxConstraints(minHeight: 60, minWidth: 60),
          iconSize: 28,
        ),
      ),
    ],
  );
}

// 8. Compare Products Screen AppBar
Widget fakeCompareAppBar() {
  return AppBar(
    toolbarHeight: 60,
    title: Container(
      height: 60,
      alignment: Alignment.centerLeft,
      child: Text('Compare Products'),
    ),
    leading: Container(
      height: 60,
      width: 60,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {},
        constraints: BoxConstraints(minHeight: 60, minWidth: 60),
        iconSize: 28,
      ),
    ),
    actions: [
      Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.clear_all),
          constraints: BoxConstraints(minHeight: 60, minWidth: 60),
          iconSize: 28,
        ),
      ),
    ],
  );
}

// 9. Recently Viewed Screen AppBar
Widget fakeRecentlyViewedAppBar() {
  return AppBar(
    toolbarHeight: 60,
    title: Container(
      height: 60,
      alignment: Alignment.centerLeft,
      child: Text('Recently Viewed'),
    ),
    leading: Container(
      height: 60,
      width: 60,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {},
        constraints: BoxConstraints(minHeight: 60, minWidth: 60),
        iconSize: 28,
      ),
    ),
    actions: [
      Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.delete_outline),
          constraints: BoxConstraints(minHeight: 60, minWidth: 60),
          iconSize: 28,
        ),
      ),
    ],
  );
}

// 10. Store Locator Screen AppBar
Widget fakeStoreLocatorAppBar() {
  return AppBar(
    toolbarHeight: 60,
    title: Container(
      height: 60,
      alignment: Alignment.centerLeft,
      child: Text('Store Locator'),
    ),
    leading: Container(
      height: 60,
      width: 60,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {},
        constraints: BoxConstraints(minHeight: 60, minWidth: 60),
        iconSize: 28,
      ),
    ),
    actions: [
      Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.my_location),
          constraints: BoxConstraints(minHeight: 60, minWidth: 60),
          iconSize: 28,
        ),
      ),
      Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.map),
          constraints: BoxConstraints(minHeight: 60, minWidth: 60),
          iconSize: 28,
        ),
      ),
    ],
  );
}

// 11. Referral Program Screen AppBar
Widget fakeReferralAppBar() {
  return AppBar(
    toolbarHeight: 60,
    title: Container(
      height: 60,
      alignment: Alignment.centerLeft,
      child: Text('Refer & Earn'),
    ),
    leading: Container(
      height: 60,
      width: 60,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {},
        constraints: BoxConstraints(minHeight: 60, minWidth: 60),
        iconSize: 28,
      ),
    ),
    actions: [
      Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.share),
          constraints: BoxConstraints(minHeight: 60, minWidth: 60),
          iconSize: 28,
        ),
      ),
    ],
  );
}

// 12. Subscription Screen AppBar
Widget fakeSubscriptionAppBar() {
  return AppBar(
    toolbarHeight: 60,
    title: Container(
      height: 60,
      alignment: Alignment.centerLeft,
      child: Text('Subscriptions'),
    ),
    leading: Container(
      height: 60,
      width: 60,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {},
        constraints: BoxConstraints(minHeight: 60, minWidth: 60),
        iconSize: 28,
      ),
    ),
    actions: [
      Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.add),
          constraints: BoxConstraints(minHeight: 60, minWidth: 60),
          iconSize: 28,
        ),
      ),
    ],
  );
}

// 13. Gift Cards Screen AppBar
Widget fakeGiftCardsAppBar() {
  return AppBar(
    toolbarHeight: 60,
    title: Container(
      height: 60,
      alignment: Alignment.centerLeft,
      child: Text('Gift Cards'),
    ),
    leading: Container(
      height: 60,
      width: 60,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {},
        constraints: BoxConstraints(minHeight: 60, minWidth: 60),
        iconSize: 28,
      ),
    ),
    actions: [
      Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.card_giftcard),
          constraints: BoxConstraints(minHeight: 60, minWidth: 60),
          iconSize: 28,
        ),
      ),
    ],
  );
}

// 14. Live Chat Screen AppBar
Widget fakeLiveChatAppBar() {
  return AppBar(
    toolbarHeight: 60,
    title: Container(
      height: 60,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            child: Icon(Icons.person, size: 20),
          ),
          SizedBox(width: 12),
          Text('Customer Support'),
        ],
      ),
    ),
    leading: Container(
      height: 60,
      width: 60,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {},
        constraints: BoxConstraints(minHeight: 60, minWidth: 60),
        iconSize: 28,
      ),
    ),
    actions: [
      Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.more_vert),
          constraints: BoxConstraints(minHeight: 60, minWidth: 60),
          iconSize: 28,
        ),
      ),
    ],
  );
}

// 15. Blog/News Screen AppBar
Widget fakeBlogAppBar() {
  return AppBar(
    toolbarHeight: 60,
    title: Container(
      height: 60,
      alignment: Alignment.centerLeft,
      child: Text('Blog & News'),
    ),
    leading: Container(
      height: 60,
      width: 60,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {},
        constraints: BoxConstraints(minHeight: 60, minWidth: 60),
        iconSize: 28,
      ),
    ),
    actions: [
      Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
          constraints: BoxConstraints(minHeight: 60, minWidth: 60),
          iconSize: 28,
        ),
      ),
      Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.bookmark_border),
          constraints: BoxConstraints(minHeight: 60, minWidth: 60),
          iconSize: 28,
        ),
      ),
    ],
  );
}

// 16. Loyalty Points Screen AppBar
Widget fakeLoyaltyAppBar() {
  return AppBar(
    toolbarHeight: 60,
    title: Container(
      height: 60,
      alignment: Alignment.centerLeft,
      child: Text('Loyalty Points'),
    ),
    leading: Container(
      height: 60,
      width: 60,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {},
        constraints: BoxConstraints(minHeight: 60, minWidth: 60),
        iconSize: 28,
      ),
    ),
    actions: [
      Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.history),
          constraints: BoxConstraints(minHeight: 60, minWidth: 60),
          iconSize: 28,
        ),
      ),
    ],
  );
}

// 17. Quick Reorder Screen AppBar
Widget fakeQuickReorderAppBar() {
  return AppBar(
    toolbarHeight: 60,
    title: Container(
      height: 60,
      alignment: Alignment.centerLeft,
      child: Text('Quick Reorder'),
    ),
    leading: Container(
      height: 60,
      width: 60,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {},
        constraints: BoxConstraints(minHeight: 60, minWidth: 60),
        iconSize: 28,
      ),
    ),
    actions: [
      Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.refresh),
          constraints: BoxConstraints(minHeight: 60, minWidth: 60),
          iconSize: 28,
        ),
      ),
    ],
  );
}

// 18. Recipe Screen AppBar
Widget fakeRecipeAppBar() {
  return AppBar(
    toolbarHeight: 60,
    title: Container(
      height: 60,
      alignment: Alignment.centerLeft,
      child: Text('Recipes'),
    ),
    leading: Container(
      height: 60,
      width: 60,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {},
        constraints: BoxConstraints(minHeight: 60, minWidth: 60),
        iconSize: 28,
      ),
    ),
    actions: [
      Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
          constraints: BoxConstraints(minHeight: 60, minWidth: 60),
          iconSize: 28,
        ),
      ),
      Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.filter_list),
          constraints: BoxConstraints(minHeight: 60, minWidth: 60),
          iconSize: 28,
        ),
      ),
    ],
  );
}

// 19. Delivery Tracking Screen AppBar
Widget fakeDeliveryTrackingAppBar() {
  return AppBar(
    toolbarHeight: 60,
    title: Container(
      height: 60,
      alignment: Alignment.centerLeft,
      child: Text('Track Delivery'),
    ),
    leading: Container(
      height: 60,
      width: 60,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {},
        constraints: BoxConstraints(minHeight: 60, minWidth: 60),
        iconSize: 28,
      ),
    ),
    actions: [
      Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.refresh),
          constraints: BoxConstraints(minHeight: 60, minWidth: 60),
          iconSize: 28,
        ),
      ),
      Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.phone),
          constraints: BoxConstraints(minHeight: 60, minWidth: 60),
          iconSize: 28,
        ),
      ),
    ],
  );
}

// 20. Return/Refund Screen AppBar
Widget fakeReturnRefundAppBar() {
  return AppBar(
    toolbarHeight: 60,
    title: Container(
      height: 60,
      alignment: Alignment.centerLeft,
      child: Text('Returns & Refunds'),
    ),
    leading: Container(
      height: 60,
      width: 60,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {},
        constraints: BoxConstraints(minHeight: 60, minWidth: 60),
        iconSize: 28,
      ),
    ),
    actions: [
      Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.help_outline),
          constraints: BoxConstraints(minHeight: 60, minWidth: 60),
          iconSize: 28,
        ),
      ),
    ],
  );
}
