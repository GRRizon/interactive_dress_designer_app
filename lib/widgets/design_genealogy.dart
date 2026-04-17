import 'package:flutter/material.dart';
import 'package:interactive_dress_designer_app/models/design_version.dart';

class DesignGenealogy extends StatelessWidget {
  final List<DesignVersion> versions;

  const DesignGenealogy({super.key, required this.versions});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        itemCount: versions.length,
        separatorBuilder: (context, index) => _buildConnector(),
        itemBuilder: (context, index) {
          final version = versions[index];
          final bool isLatest = index == versions.length - 1;

          return Column(
            children: [
              Container(
                width: 80,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isLatest ? Colors.indigo : Colors.grey.shade300,
                    width: isLatest ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Container(
                  color: Colors.blue,
                  child: const Center(child: Icon(Icons.image)),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                version.description,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildConnector() {
    return Container(
      width: 30,
      height: 2,
      margin: const EdgeInsets.only(
        bottom: 40,
      ), // Align with the center of the cards
      color: Colors.grey.shade300,
    );
  }
}
