import 'package:flutter/material.dart';

class VehicleReviewPage extends StatelessWidget {
  const VehicleReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final reviews = [
      Review(
        name: "Daniel Foster",
        time: "2 days ago",
        rating: 4,
        comment:
            "The driver was very professional and the vehicle was clean. Pickup was on time and the journey was smooth.",
      ),
      Review(
        name: "Emily Watson",
        time: "5 days ago",
        rating: 5,
        comment:
            "Amazing experience! The car was comfortable and spacious. Definitely booking again next time.",
      ),
      Review(
        name: "Michael Lee",
        time: "1 week ago",
        rating: 3,
        comment:
            "Overall it was good, but the driver arrived a bit late. The ride itself was fine though.",
      ),
      Review(
        name: "Sophia Turner",
        time: "2 weeks ago",
        rating: 4,
        comment:
            "Nice and smooth trip. The booking process was simple and the driver was friendly.",
      ),
      Review(
        name: "James Walker",
        time: "3 weeks ago",
        rating: 5,
        comment:
            "Great service. Clean vehicle and very polite driver. Highly recommended!",
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xfff2f3f5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          "Vehicle Reviews",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// OVERALL RATING
            const Text(
              "Overall Rating",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 8),

            const Text(
              "4.2",
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            /// STARS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  color: index < 4 ? Colors.amber : Colors.grey[300],
                ),
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Based on 20 reviews",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 16),

            /// RATING BREAKDOWN
            _buildRatingBar(5, 0.7),
            _buildRatingBar(4, 0.5),
            _buildRatingBar(3, 0.3),
            _buildRatingBar(2, 0.15),
            _buildRatingBar(1, 0.1),

            const SizedBox(height: 16),

            /// REVIEW LIST (show first 3)
            Expanded(
              child: ListView(
                children: [
                  ReviewItem(review: reviews[0]),
                  ReviewItem(review: reviews[1]),
                  ReviewItem(review: reviews[2]),

                  const SizedBox(height: 10),

                  /// SHOW MORE
                  Center(
                    child: TextButton(
                      onPressed: () {
                        _showMoreReviews(context, reviews);
                      },
                      child: const Text(
                        "Show more reviews",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// SHOW MORE REVIEWS
  void _showMoreReviews(BuildContext context, List<Review> reviews) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reviews.length,
            itemBuilder: (_, index) {
              return ReviewItem(review: reviews[index]);
            },
          ),
        );
      },
    );
  }

  /// RATING BAR
  Widget _buildRatingBar(int star, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 20, child: Text("$star")),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 10,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Colors.redAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Review {
  final String name;
  final String time;
  final int rating;
  final String comment;

  Review({
    required this.name,
    required this.time,
    required this.rating,
    required this.comment,
  });
}

/// REVIEW ITEM
class ReviewItem extends StatelessWidget {
  final Review review;

  const ReviewItem({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// AVATAR
          CircleAvatar(radius: 22, child: Text(review.name[0])),

          const SizedBox(width: 10),

          /// CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// NAME + TIME
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      review.time,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                /// STARS
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      size: 16,
                      color: index < review.rating
                          ? Colors.amber
                          : Colors.grey[300],
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                /// COMMENT
                Text(
                  review.comment,
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
