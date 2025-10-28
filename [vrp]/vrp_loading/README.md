# vRP Loading Screen (QBCore-Based)

A custom loading screen for vRP servers, inspired by the popular QBCore loading screen style. This screen provides a clean, professional welcome experience while players load into your server.
# Features

  * Sleek, QBCore-inspired design
  * Customizable messages
  * Progress bar for loading assets
  * Dynamic background images and music support

# Installation

1. ### Download the Repository:
    * Clone or download the repository files from GitHub.

2. ### Locate vrp_loading-main:
   #### using `extract here` method
    * rename the folder to `vrp_loading` or just drop the `-main`.
   #### using `extract files...` method
    * rename the file inside to `vrp_loading` or just drop the `-main`.

4. ### Add vrp_loading to Your Server:
    * Drag and drop the vrp_loading folder into your server’s resources folder.

5. ### Add to Server Config:
    * Open your server configuration file (usually server.cfg) and add the following line to ensure the loading screen starts up with the server:

      `ensure vrp_loading`

6. ### Customize (Optional):
    * Inside vrp_loading/html, you can customize various aspects of the loading screen, including images, text messages, and music. Edit the config.lua file to personalize your server's loading experience.

7. ### Restart Your Server:
    * Once installed and configured, restart your server to apply the loading screen.

# Customization

  * Background Images: Add your images to the html/images folder and update the paths in the configuration file.
  * Music: Replace the default music file in html/music with your own, or specify a URL.
  * Text Messages: Edit the HTML files to display custom messages to your players as they load in.

#

Enjoy your custom vRP loading screen, and welcome your players in style! For further assistance or feature requests, feel free to open an issue or submit a pull request.
