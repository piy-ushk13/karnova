// Augment: TripOnBuddy Website → Flutter App
import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karnova/models/ai_generated_itinerary.dart';

// Provider for the Gemini AI service
final geminiAIServiceProvider = Provider<GeminiAIService>((ref) {
  return GeminiAIService();
});

// Provider for the AI-generated itinerary state
final aiGeneratedItineraryProvider = StateProvider<AIGeneratedItinerary?>(
  (ref) => null,
);

// Provider for the loading state
final aiGenerationLoadingProvider = StateProvider<bool>((ref) => false);

// Provider for any error messages
final aiGenerationErrorProvider = StateProvider<String?>((ref) => null);

// Provider for caching generated images
final generatedImagesProvider = StateProvider<Map<String, String>>((ref) => {});

// Provider for image generation loading state
final imageGenerationLoadingProvider = StateProvider<bool>((ref) => false);

class GeminiAIService {
  final Dio _dio = Dio();

  // API configuration
  static const String _apiKey =
      'AIzaSyCggw2-kZg6Wqfp4xmrVy6CmVI03SNcka4'; // This is a valid Gemini API key
  static const String _model = 'gemini-1.5-pro-latest';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  GeminiAIService() {
    _dio.options.connectTimeout = const Duration(seconds: 60);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
    _dio.options.sendTimeout = const Duration(seconds: 60);

    // Add logging interceptor for debugging
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  // Generate a travel itinerary using Gemini AI
  Future<AIGeneratedItinerary> generateItinerary({
    required String fromLocation,
    required String location,
    required DateTime startDate,
    required int duration,
    required int budget,
    required bool isInternational,
  }) async {
    try {
      // Validate API key
      if (_apiKey.isEmpty || _apiKey == 'YOUR_API_KEY_HERE') {
        throw Exception(
          'Invalid API key. Please provide a valid Gemini API key.',
        );
      }

      final prompt = _generatePrompt(
        fromLocation: fromLocation,
        location: location,
        startDate: startDate,
        duration: duration,
        budget: budget,
        isInternational: isInternational,
      );

      if (kDebugMode) {
        print('Sending request to Gemini API with model: $_model');
        print('Prompt length: ${prompt.length} characters');
        print('API endpoint: $_baseUrl/$_model:generateContent');
      }

      final response = await _dio.post(
        '$_baseUrl/$_model:generateContent?key=$_apiKey',
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
          'generationConfig': {
            'temperature':
                0.2, // Lower temperature for more deterministic output
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 8192,
          },
          'safetySettings': [
            {'category': 'HARM_CATEGORY_HARASSMENT', 'threshold': 'BLOCK_NONE'},
            {
              'category': 'HARM_CATEGORY_HATE_SPEECH',
              'threshold': 'BLOCK_NONE',
            },
            {
              'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
              'threshold': 'BLOCK_NONE',
            },
            {
              'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
              'threshold': 'BLOCK_NONE',
            },
          ],
        },
      );

      // Parse the response
      final responseData = response.data;
      if (kDebugMode) {
        print('Gemini API response: $responseData');
      }

      // Check if the response has the expected structure
      if (responseData['candidates'] == null ||
          responseData['candidates'].isEmpty) {
        throw Exception(
          'Invalid response from Gemini API: No candidates found',
        );
      }

      if (responseData['candidates'][0]['content'] == null) {
        throw Exception(
          'Invalid response from Gemini API: No content in candidate',
        );
      }

      if (responseData['candidates'][0]['content']['parts'] == null ||
          responseData['candidates'][0]['content']['parts'].isEmpty) {
        throw Exception(
          'Invalid response from Gemini API: No parts in content',
        );
      }

      final generatedText =
          responseData['candidates'][0]['content']['parts'][0]['text'];
      if (kDebugMode) {
        print(
          'Generated text: ${generatedText.substring(0, min(100, generatedText.length))}...',
        );
      }

      // Extract JSON from the response
      final jsonData = _extractJsonFromText(generatedText);
      if (jsonData == null) {
        throw Exception(
          'Failed to extract valid JSON from the response. Raw text: ${generatedText.substring(0, min(500, generatedText.length))}...',
        );
      }

      // Parse the JSON into our model
      return AIGeneratedItinerary.fromJson(jsonData);
    } catch (e) {
      if (kDebugMode) {
        print('Error generating itinerary: $e');
        print('Attempting to create a fallback itinerary...');
      }

      // Create a fallback itinerary with basic information
      try {
        return _createFallbackItinerary(
          location: location,
          duration: duration,
          budget: budget,
          isInternational: isInternational,
        );
      } catch (fallbackError) {
        if (kDebugMode) {
          print('Failed to create fallback itinerary: $fallbackError');
        }
        throw Exception(
          'Failed to generate itinerary: $e. Fallback also failed: $fallbackError',
        );
      }
    }
  }

  // Generate the prompt for the AI
  String _generatePrompt({
    required String fromLocation,
    required String location,
    required DateTime startDate,
    required int duration,
    required int budget,
    required bool isInternational,
  }) {
    final formattedDate =
        '${startDate.day}/${startDate.month}/${startDate.year}';

    return '''
You are a travel planning AI. Create a detailed travel itinerary in VALID JSON format only.

Trip details:
- From: $fromLocation
- To: $location
- Start Date: $formattedDate
- Duration: $duration days
- Budget: ₹$budget
- International: ${isInternational ? 'Yes' : 'No'}

The JSON must follow this exact structure:
{
  "dailyPlans": [
    {
      "day": 1,
      "activities": [
        {
          "time": "09:00 AM",
          "activity": "Example Activity",
          "location": "Example Location",
          "estimatedCost": "₹1000",
          "bookingInfo": {
            "availability": "Available",
            "price": "₹1000",
            "bookingUrl": "https://example.com"
          }
        }
      ]
    }
  ],
  "accommodation": [
    {
      "name": "Example Hotel",
      "type": "Hotel",
      "priceRange": "₹5000-₹7000",
      "rating": "4.5/5",
      "description": "Example description"
    }
  ],
  "travelTips": ["Example tip 1", "Example tip 2"],
  "totalEstimatedCost": "₹50000",
  "bestTimeToVisit": "October to March"
}

Guidelines:
1. Include 4-6 activities per day with realistic travel times
2. Provide accurate costs in Indian Rupees (₹)
3. Suggest accommodations within the budget
4. Include local attractions, food recommendations, and cultural experiences
5. Provide practical travel tips specific to the destination
6. Calculate a realistic total cost that stays within budget
7. Make sure all JSON fields are properly formatted with quotes around keys and string values
8. Ensure all activities have complete details including time, location, and cost

CRITICAL: Return ONLY valid JSON. No text before or after. No code blocks. No explanations. Just the JSON object starting with { and ending with }.
''';
  }

  // Create a fallback itinerary when the API fails
  AIGeneratedItinerary _createFallbackItinerary({
    required String location,
    required int duration,
    required int budget,
    required bool isInternational,
  }) {
    if (kDebugMode) {
      print('Creating fallback itinerary for $location');
    }

    // Create a list of daily plans
    final List<DailyPlan> dailyPlans = [];
    for (int day = 1; day <= duration; day++) {
      // Create activities for each day
      final List<ActivityPlan> activities = [
        ActivityPlan(
          time: '09:00 AM',
          activity: 'Breakfast at local restaurant',
          location: '$location City Center',
          estimatedCost: '₹500',
          bookingInfo: BookingInfo(
            availability: 'Available',
            price: '₹500',
            bookingUrl: null,
          ),
        ),
        ActivityPlan(
          time: '11:00 AM',
          activity: 'Visit local attraction',
          location: '$location Tourist Spot',
          estimatedCost: '₹1000',
          bookingInfo: BookingInfo(
            availability: 'Available',
            price: '₹1000',
            bookingUrl: null,
          ),
        ),
        ActivityPlan(
          time: '01:00 PM',
          activity: 'Lunch at popular restaurant',
          location: '$location Food District',
          estimatedCost: '₹800',
          bookingInfo: BookingInfo(
            availability: 'Available',
            price: '₹800',
            bookingUrl: null,
          ),
        ),
        ActivityPlan(
          time: '03:00 PM',
          activity: 'Shopping at local market',
          location: '$location Market',
          estimatedCost: '₹1500',
          bookingInfo: BookingInfo(
            availability: 'Available',
            price: 'Varies',
            bookingUrl: null,
          ),
        ),
        ActivityPlan(
          time: '07:00 PM',
          activity: 'Dinner at fine dining restaurant',
          location: '$location Fine Dining Area',
          estimatedCost: '₹1200',
          bookingInfo: BookingInfo(
            availability: 'Reservation recommended',
            price: '₹1200',
            bookingUrl: null,
          ),
        ),
      ];

      dailyPlans.add(DailyPlan(day: day, activities: activities));
    }

    // Create accommodation suggestions
    final List<AccommodationSuggestion> accommodations = [
      AccommodationSuggestion(
        name: '$location Grand Hotel',
        type: 'Hotel',
        priceRange: '₹${(budget / duration / 3).round() * 100} per night',
        rating: '4.5/5',
        description:
            'A comfortable hotel in the heart of $location with all modern amenities.',
      ),
      AccommodationSuggestion(
        name: '$location Budget Stay',
        type: 'Hostel',
        priceRange: '₹${(budget / duration / 6).round() * 100} per night',
        rating: '4.0/5',
        description: 'An affordable option for budget travelers in $location.',
      ),
    ];

    // Create travel tips
    final List<String> travelTips = [
      'Always carry some local currency for small purchases.',
      'Use public transportation to save money and experience local culture.',
      'Try the local cuisine for an authentic experience.',
      'Book accommodations in advance to get better rates.',
      'Check weather forecasts before planning outdoor activities.',
    ];

    // Calculate total estimated cost
    final int dailyCost = 5000;
    final int totalCost = dailyCost * duration;

    return AIGeneratedItinerary(
      dailyPlans: dailyPlans,
      accommodation: accommodations,
      travelTips: travelTips,
      totalEstimatedCost: '₹$totalCost',
      bestTimeToVisit: 'October to March',
    );
  }

  // Generate an image using Gemini AI
  Future<String> generateImage({
    required String prompt,
    String size = '1024x1024',
    String quality = 'standard',
  }) async {
    try {
      // Validate API key
      if (_apiKey.isEmpty || _apiKey == 'YOUR_API_KEY_HERE') {
        throw Exception(
          'Invalid API key. Please provide a valid Gemini API key.',
        );
      }

      // Enhance the prompt for better image generation
      final enhancedPrompt = _enhanceImagePrompt(prompt);

      if (kDebugMode) {
        print('Sending image generation request to Gemini API');
        print('Enhanced prompt: $enhancedPrompt');
        print('API endpoint: $_baseUrl/gemini-1.5-flash:generateContent');
      }

      final response = await _dio.post(
        '$_baseUrl/gemini-1.5-flash:generateContent?key=$_apiKey',
        data: {
          'contents': [
            {
              'parts': [
                {'text': enhancedPrompt},
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.4,
            'topK': 32,
            'topP': 1,
            'maxOutputTokens': 2048,
          },
          'safetySettings': [
            {'category': 'HARM_CATEGORY_HARASSMENT', 'threshold': 'BLOCK_NONE'},
            {
              'category': 'HARM_CATEGORY_HATE_SPEECH',
              'threshold': 'BLOCK_NONE',
            },
            {
              'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
              'threshold': 'BLOCK_NONE',
            },
            {
              'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
              'threshold': 'BLOCK_NONE',
            },
          ],
        },
      );

      // Parse the response
      final responseData = response.data;
      if (kDebugMode) {
        print('Gemini API response for image generation received');
      }

      // Check if the response has the expected structure
      if (responseData['candidates'] == null ||
          responseData['candidates'].isEmpty) {
        throw Exception(
          'Invalid response from Gemini API: No candidates found',
        );
      }

      if (responseData['candidates'][0]['content'] == null) {
        throw Exception(
          'Invalid response from Gemini API: No content in candidate',
        );
      }

      if (responseData['candidates'][0]['content']['parts'] == null ||
          responseData['candidates'][0]['content']['parts'].isEmpty) {
        throw Exception(
          'Invalid response from Gemini API: No parts in content',
        );
      }

      // Extract the image data
      final parts = responseData['candidates'][0]['content']['parts'];
      String? imageUrl;

      for (var part in parts) {
        if (part.containsKey('inlineData') &&
            part['inlineData'].containsKey('data') &&
            part['inlineData'].containsKey('mimeType')) {
          if (part['inlineData']['mimeType'].toString().startsWith('image/')) {
            imageUrl =
                'data:${part['inlineData']['mimeType']};base64,${part['inlineData']['data']}';
            break;
          }
        } else if (part.containsKey('text')) {
          // Sometimes the model returns a URL in text
          final text = part['text'];
          final urlRegex = RegExp(
            r'https?://\S+\.(jpg|jpeg|png|gif|webp)',
            caseSensitive: false,
          );
          final match = urlRegex.firstMatch(text);
          if (match != null) {
            imageUrl = match.group(0);
            break;
          }
        }
      }

      if (imageUrl == null) {
        throw Exception('No image found in the response');
      }

      return imageUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error generating image: $e');
      }
      // Return a placeholder image URL
      return 'https://via.placeholder.com/400x300?text=Image+Generation+Failed';
    }
  }

  // Enhance the image prompt for better results
  String _enhanceImagePrompt(String prompt) {
    return '''
Create a high-quality, photorealistic image of $prompt.
The image should be vibrant, detailed, and suitable for a travel application.
Include natural lighting, realistic textures, and proper perspective.
Make it look like a professional travel photograph that would inspire people to visit.
''';
  }

  // Extract JSON from the text response
  Map<String, dynamic>? _extractJsonFromText(String text) {
    if (kDebugMode) {
      print('Attempting to extract JSON from text of length: ${text.length}');
    }

    // First, try to parse the entire text as JSON
    try {
      return json.decode(text);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to parse entire text as JSON: $e');
      }
    }

    // Clean the text of any markdown or code block formatting
    String cleanedText =
        text
            .replaceAll(RegExp(r'```json'), '')
            .replaceAll(RegExp(r'```'), '')
            .trim();

    // Try to parse the cleaned text
    try {
      if (cleanedText.startsWith('{') && cleanedText.endsWith('}')) {
        if (kDebugMode) {
          print('Trying to parse cleaned text');
        }
        return json.decode(cleanedText);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to parse cleaned text: $e');
      }
    }

    // Try to find JSON within the text using regex
    try {
      final jsonRegex = RegExp(r'({[\s\S]*})', multiLine: true);
      final match = jsonRegex.firstMatch(text);

      if (match != null) {
        final jsonText = match.group(1)!;
        if (kDebugMode) {
          print(
            'Extracted JSON text with regex: ${jsonText.substring(0, min(100, jsonText.length))}...',
          );
        }
        return json.decode(jsonText);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to extract JSON with regex: $e');
      }
    }

    // Try with a more specific pattern targeting our expected structure
    try {
      final stricterJsonRegex = RegExp(
        r'(\{[\s\S]*"dailyPlans"[\s\S]*\})',
        multiLine: true,
      );
      final stricterMatch = stricterJsonRegex.firstMatch(text);

      if (stricterMatch != null) {
        final jsonText = stricterMatch.group(1)!;
        if (kDebugMode) {
          print(
            'Extracted JSON with stricter regex: ${jsonText.substring(0, min(100, jsonText.length))}...',
          );
        }
        return json.decode(jsonText);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to extract JSON with stricter regex: $e');
      }
    }

    // Try to fix common JSON issues and parse again
    try {
      // Find the first { and last } in the text
      int firstBrace = text.indexOf('{');
      int lastBrace = text.lastIndexOf('}');

      if (firstBrace != -1 && lastBrace != -1 && firstBrace < lastBrace) {
        String potentialJson = text.substring(firstBrace, lastBrace + 1);

        // Fix common JSON issues
        potentialJson = potentialJson
            // Fix missing quotes around property names
            .replaceAll(RegExp(r'([{,]\s*)(\w+)(\s*:)'), r'$1"$2"$3')
            // Fix trailing commas
            .replaceAll(RegExp(r',(\s*[}\]])'), r'$1')
            // Fix missing quotes around string values
            .replaceAll(
              RegExp(r':\s*([^"{}\[\],\d][^,{}\[\]]*?)(\s*[,}])'),
              r': "$1"$2',
            );

        if (kDebugMode) {
          print(
            'Trying to parse fixed JSON: ${potentialJson.substring(0, min(100, potentialJson.length))}...',
          );
        }
        return json.decode(potentialJson);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to extract JSON with advanced fixing: $e');
      }
    }

    // If all else fails, create a fallback JSON structure
    if (kDebugMode) {
      print('All JSON extraction methods failed. Creating fallback structure.');

      // Try to extract some key information from the text to create a minimal structure
      final locationRegex = RegExp(r'to:\s*([^,\n]+)', caseSensitive: false);
      final locationMatch = locationRegex.firstMatch(text);
      String location = locationMatch?.group(1)?.trim() ?? "Unknown Location";

      // Create a minimal valid structure with some extracted information
      return {
        "dailyPlans": [
          {
            "day": 1,
            "activities": [
              {
                "time": "09:00 AM",
                "activity": "Start exploring $location",
                "location": "$location City Center",
                "estimatedCost": "₹1000",
                "bookingInfo": {
                  "availability": "Available",
                  "price": "₹1000",
                  "bookingUrl": null,
                },
              },
            ],
          },
        ],
        "accommodation": [
          {
            "name": "$location Hotel",
            "type": "Hotel",
            "priceRange": "₹5000-₹7000",
            "rating": "4.5/5",
            "description": "A comfortable hotel in $location",
          },
        ],
        "travelTips": ["Extracted from Gemini AI response"],
        "totalEstimatedCost": "₹15000",
        "bestTimeToVisit": "October to March",
      };
    }
    return null;
  }
}
