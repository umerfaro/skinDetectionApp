# SkinSleuth AI - Skin Health Tracker

A Flutter app for skin health analysis using AI-powered detection through Replicate API.

## Features

- 📸 Capture images with camera or select from gallery
- 🔄 Image compression and optimization
- 🤖 AI-powered skin analysis via Replicate
- 📊 Detailed analysis reports
- 💡 Medical recommendations and risk assessment

## Setup Instructions

### 1. Flutter Environment
```bash
flutter doctor
flutter pub get
```

### 2. Replicate API Setup

#### Get Your API Key:
1. Visit [Replicate.com](https://replicate.com) and create an account
2. Go to Account Settings → API Tokens
3. Create a new token and copy it
4. Replace `YOUR_REPLICATE_API_TOKEN_HERE` in `lib/services/replicate_service.dart`

#### Available Models:
- For production, replace the model version with a dermatology-specific model
- Current implementation uses mock data for development
- Popular skin analysis models on Replicate include medical imaging models

### 3. Dependencies
```yaml
dependencies:
  http: ^1.1.0  # For API calls
  get: ^4.6.6   # State management
  image_picker: ^1.0.7  # Image selection
  flutter_image_compress: ^2.2.0  # Image optimization
```

### 4. Run the App
```bash
flutter run
```

## App Flow

1. **Welcome Screen**: Choose camera or gallery
2. **Confirm Image**: Review selected image
3. **Analysis**: AI processes the image via Replicate API
4. **Report Screen**: View detailed results and recommendations

## Replicate Integration

The app integrates with [Replicate](https://replicate.com) for AI-powered skin analysis:

- **Service**: `lib/services/replicate_service.dart`
- **Mock Mode**: For development without API calls
- **Production Mode**: Replace mock with actual Replicate API calls

### Using Real Replicate API:
```dart
// Replace in confirmImageController.dart:
final result = await ReplicateService.analyzeImage(imageFile);
```

## Security Notes

- Never commit API keys to version control
- Use environment variables for production
- Implement proper error handling for API failures
- Consider rate limiting and usage monitoring

## Development vs Production

**Development**: Uses mock data for faster iteration
**Production**: Requires valid Replicate API key and proper image hosting

## Contributing

1. Fork the repository
2. Create a feature branch
3. Implement changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Screenshots

Here's a glimpse of the TrackerApp:

| Screenshot 1                                      | Screenshot 2                                        | Screenshot 3                                       |
| :------------------------------------------------: | :------------------------------------------------: | :------------------------------------------------: |
| ![App Screenshot 1](https://raw.githubusercontent.com/umerfaro/mtbc-Trackerapp/9b4f241d247b80840f35385e3464eb1613664802/download.png) | ![App Screenshot 2](https://raw.githubusercontent.com/umerfaro/mtbc-Trackerapp/9b4f241d247b80840f35385e3464eb1613664802/download%20(1).png) | ![App Screenshot 3](https://raw.githubusercontent.com/umerfaro/mtbc-Trackerapp/9b4f241d247b80840f35385e3464eb1613664802/download%20(2).png) |

| Screenshot 4                                      | Screenshot 5                                        | *(Add more if needed)* |
| :------------------------------------------------: | :------------------------------------------------: | :------------------------------------------------: |
| ![App Screenshot 4](https://raw.githubusercontent.com/umerfaro/mtbc-Trackerapp/9b4f241d247b80840f35385e3464eb1613664802/download%20(3).png) | ![App Screenshot 5](https://raw.githubusercontent.com/umerfaro/mtbc-Trackerapp/9b4f241d247b80840f35385e3464eb1613664802/download%20(4).png) |  |

## Project Structure

A brief overview of how the project is structured:
