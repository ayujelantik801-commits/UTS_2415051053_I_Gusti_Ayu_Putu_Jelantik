import 'package:flutter/material.dart';

/// Input rating bintang 1-5 yang bisa divalidasi di dalam Form.
class RatingInput extends FormField<int> {
  RatingInput({super.key, super.initialValue = 0, super.validator, super.onSaved})
      : super(
          builder: (state) {
            final value = state.value ?? 0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    for (var i = 1; i <= 5; i++)
                      IconButton(
                        onPressed: () => state.didChange(i),
                        icon: Icon(
                          i <= value ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                      ),
                  ],
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(
                        color: Theme.of(state.context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
}