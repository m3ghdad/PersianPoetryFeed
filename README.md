# Persian Poetry App

A TikTok-style iOS app that displays Persian poetry overlaid on background videos, using the Ganjoor API.

## Features

- **TikTok-style Feed**: Vertical scrolling interface with full-screen videos
- **Persian Poetry Overlay**: Beautiful Persian text displayed over video backgrounds
- **Swipe Navigation**: Swipe up/down to navigate between poems
- **Auto-refresh**: Tap the home tab to refresh with new random poems
- **Video Backgrounds**: Curated video backgrounds for each poem
- **Persian Text Support**: Proper RTL text rendering for Persian poetry

## Architecture

### Models
- `Poem.swift`: Data models for poems, poets, and categories from Ganjoor API

### Services
- `APIService.swift`: Handles all Ganjoor API calls
- `VideoService.swift`: Manages background video URLs and playback

### Views
- `PoetryFeedView.swift`: Main TikTok-style feed interface
- `MainTabView.swift`: Tab bar navigation
- `ContentView.swift`: Root view controller

## API Integration

The app integrates with the Ganjoor API (https://api.ganjoor.net) to fetch:
- Random Persian poems
- Poet information
- Poem metadata

## Usage

1. **Navigation**: Swipe up/down to browse poems
2. **Refresh**: Tap the home tab to load new random poems
3. **Double-tap**: Double-tap any poem to refresh the feed

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+

## Installation

1. Open `PersianPoetry.xcodeproj` in Xcode
2. Build and run on iOS Simulator or device
3. The app will automatically fetch random Persian poems on launch

## Features in Detail

### Video Integration
- Uses AVPlayer for smooth video playback
- Videos loop automatically
- Optimized for vertical scrolling

### Persian Text Rendering
- Proper RTL (Right-to-Left) text alignment
- Persian font support
- Text shadows for better readability over videos

### API Integration
- Fetches random poems from Ganjoor API
- Handles network errors gracefully
- Loading states and error handling

## Future Enhancements

- Search functionality
- Favorites system
- User profiles
- Social sharing
- Offline support
# PersianPoetryFeed
