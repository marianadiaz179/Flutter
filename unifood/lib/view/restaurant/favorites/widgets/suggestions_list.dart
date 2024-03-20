import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unifood/model/restaurant_entity.dart';
import 'package:unifood/view/restaurant/favorites/widgets/custom_category_button.dart';
import 'package:unifood/view/restaurant/favorites/widgets/custom_suggested_restaurant.dart';
import 'package:unifood/view_model/restaurant_view_model.dart';

class SuggestedRestaurantsSection extends StatefulWidget {
  final String userId;

  const SuggestedRestaurantsSection({Key? key, required this.userId}) : super(key: key);

  @override
  _SuggestedRestaurantsSectionState createState() => _SuggestedRestaurantsSectionState();
}

class _SuggestedRestaurantsSectionState extends State<SuggestedRestaurantsSection> {
  late String filter = 'price';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.007),
              child: Text(
                'Suggested for you',
                style: TextStyle(fontFamily: 'KeaniaOne', fontSize: screenWidth * 0.06),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(left: screenWidth * 0.1, right: screenWidth * 0.025),
          height: screenHeight * 0.005,
          color: const Color(0xFF965E4E),
        ),
        SizedBox(height: screenHeight * 0.02),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomCategoryButton(
                onPressed: () {
                  setState(() {
                    filter = 'restrictions';
                  });
                },
                text: 'Restrictions',
              ),
              CustomCategoryButton(
                onPressed: () {
                  setState(() {
                    filter = 'price';
                  });
                },
                text: 'Price',
              ),
              CustomCategoryButton(
                onPressed: () {
                  setState(() {
                    filter = 'tastes';
                  });
                },
                text: 'Food type',
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        FutureBuilder<List<Restaurant>>(
          future: RestaurantViewModel().getRecommendedRestaurants(widget.userId, filter), // Usar el filtro actual
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SpinKitThreeBounce(
                  color: Colors.black,
                  size: screenHeight * 0.03,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final List<Restaurant> suggestedRestaurants = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: suggestedRestaurants.map((restaurant) {
                    return CustomSuggestedRestaurant(
                      restaurantName: restaurant.name,
                      restaurantImage: restaurant.imageUrl,
                      restaurantPrice: restaurant.avgPrice,
                      onTap: () {}, // Define la acción al hacer clic en el restaurante
                    );
                  }).toList(),
                ),
              );
            } else {
              return const Text('No data available.');
            }
          },
        ),
      ],
    );
  }
}