import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final Widget Function() buildOrdersPage;
  final Widget Function() buildFavouritesPage;

  const ProfileScreen({
    super.key,
    required this.buildOrdersPage,
    required this.buildFavouritesPage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 28, child: Icon(Icons.person, size: 28)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Михаил Черепов',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Профиль',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: Icon(Icons.receipt_long),
              title: Text('История покупок'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => buildOrdersPage()));
              },
            ),
          ),
          SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Избранное'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => buildFavouritesPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
