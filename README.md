# Twitch Chat Overlay for macOS

A lightweight **macOS overlay app** that displays **Twitch chat** as a floating transparent window. Perfect for **streamers** and viewers who want to keep chat visible while playing **fullscreen windowed games** like World of Warcraft, League of Legends, Valorant, and more.

![macOS](https://img.shields.io/badge/macOS-12.0+-blue)
![Swift](https://img.shields.io/badge/Swift-5.0+-orange)
![License](https://img.shields.io/badge/License-All%20Rights%20Reserved-red)

## Features

- **Floating Overlay Window** - Stays on top of other windows, including fullscreen windowed games
- **Glassmorphic Design** - Beautiful Apple-style translucent glass card appearance
- **Minimal Chat Style** - Option to show only usernames and messages with transparent background
- **Adjustable Text Size** - Small, Medium, or Large text for minimal chat style
- **Opacity Controls** - Separate sliders for background and content transparency
- **Click-Through Mode** - Let mouse clicks pass through to interact with games underneath
- **Global Hotkey** - Toggle click-through with Ctrl+§ from anywhere, even in-game
- **Resizable & Draggable** - Position and size the overlay to your preference
- **Persistent Settings** - Window position and settings saved between sessions
- **Status Bar Menu** - Quick access from the macOS menu bar

## Screenshots

*Overlay showing Twitch chat on top of a game with glassmorphic transparency*

## Requirements

- macOS 12.0 (Monterey) or later
- Apple Silicon or Intel Mac

## Download

Download the latest release from the [Releases](../../releases) page.

1. Download `Overlay.dmg`
2. Open the DMG and drag **Overlay** to your **Applications** folder
3. Launch Overlay from Applications

## Usage

### Setting Up Twitch Chat

1. Open [Twitch](https://twitch.tv) in your browser
2. Navigate to the channel whose chat you want to display
3. Click the chat settings gear icon and select **"Popout Chat"**
4. Copy the URL from the popout window
   (e.g., `https://www.twitch.tv/popout/channelname/chat`)
5. Open Overlay settings and paste the URL
6. Click **"Apply URL"**

### Controls

| Action | Method |
|--------|--------|
| Move window | Drag the handle bar at the top |
| Resize window | Drag window edges or corners |
| Toggle click-through | Press **Ctrl+§** (global hotkey) |
| Open settings | Click status bar icon → Settings, or **Cmd+,** |
| Show/Hide overlay | Click status bar icon → Show/Hide Overlay |

### Settings

| Setting | Description |
|---------|-------------|
| **Twitch Chat URL** | The popout chat URL from Twitch |
| **Minimal chat style** | Hides Twitch UI, shows only messages |
| **Text Size** | Small, Medium, or Large (minimal style only) |
| **Background Opacity** | Transparency of the glass background |
| **Content Opacity** | Transparency of the chat content |
| **Click-Through Mode** | Enable to interact with windows underneath |
| **Reset Window Position** | Centers the overlay with default size |

## Game Compatibility

Works with any game or application using **fullscreen windowed** (borderless) mode:

- **World of Warcraft (WoW)**
- **League of Legends (LoL)**
- **Valorant**
- **Final Fantasy XIV (FFXIV)**
- **Counter-Strike 2 (CS2)**
- **Dota 2**
- **Overwatch 2**
- **Diablo IV**
- **Path of Exile**
- Most modern games with "Fullscreen (Windowed)" or "Borderless" display option

> **Note:** True exclusive fullscreen mode bypasses the window system and will hide the overlay. Use fullscreen windowed/borderless mode for best results.

## Troubleshooting

### Overlay not visible in game
Ensure the game is using "Fullscreen Windowed" or "Borderless" mode, not exclusive fullscreen.

### Global hotkey not working
1. Open **System Settings** → **Privacy & Security** → **Accessibility**
2. Enable **Overlay** in the list
3. Restart the app after granting permissions

### Chat not loading
- Verify the URL is a valid Twitch popout chat URL
- Check your internet connection
- Try refreshing by re-applying the URL in settings

### Window moved off-screen
Use **Settings → Reset Window Position** to bring it back to center.

## Tech Stack

- **Swift 5** - Modern Swift programming language
- **SwiftUI** - Declarative UI framework for settings
- **AppKit** - Native macOS window management
- **WebKit** - WKWebView for rendering Twitch chat

## Keywords

macOS Twitch chat overlay, streaming overlay app, transparent chat window, floating overlay for games, Twitch chat on screen, OBS alternative overlay, stream chat desktop app, gaming chat overlay Mac, borderless window overlay, click-through overlay macOS

## License

All Rights Reserved © 2026

This software is proprietary. No permission is granted to use, copy, modify, or distribute this software or its source code without explicit written permission from the author.
