import 'package:flutter/material.dart';
import 'package:preptime/theme/theme.dart';

class LoadingCard extends StatelessWidget {
  const LoadingCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 300,
                      height: 15,
                      color: Theme.of(context).hoverColor,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: 300,
                      height: 15,
                      color: Theme.of(context).hoverColor,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 300,
                      height: 15,
                      color: Theme.of(context).hoverColor,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 200,
                      height: 15,
                      color: Theme.of(context).hoverColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Chip(
                    side: chipBorderOnColor,
                    label: const Text(
                      '   ',
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Chip(
                    side: chipBorderOnColor,
                    label: const Text(
                      '   ',
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Chip(
                    side: chipBorderOnColor,
                    label: const Text(
                      '   ',
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 15,
                      color: Theme.of(context).hoverColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 130,
                      height: 15,
                      color: Theme.of(context).hoverColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
