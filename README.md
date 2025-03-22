# RoadMate (Antino E-Hackathon)

RoadMate is a comprehensive Flutter-based mobile application designed to assist drivers during roadside emergencies and vehicle breakdowns. It provides real-time solutions ranging from DIY troubleshooting guides to immediate connections with nearby mechanics, emergency services, and roadside assistance. The app leverages Firebase for authentication and data storage, Google Maps and Places APIs for location-based services, and a cutting-edge chatbot powered by Google Gemini API to deliver multilingual support and step-by-step guidance. Also I will update this GitHub repository with some bug fixes and app updates so, I will be providing new APK files in my GitHub repository so please download the updated APK files from my GitHub repository to check out the updated APK. You can use the APK files to quickly download the app and use on your mobile (android device).
The codes for the app is present inside the [lib folder](lib/) of this repository.
Download the app directy from this [APK file](app-release.apk)

## Table of Contents
- [Problem Statement](#problem-statement)
- [Solution Overview](#solution-overview)
- [Setup & Installation](#setup--installation)
  - [Prerequisites](#prerequisites)
  - [Steps to Set Up](#steps-to-set-up)
- [Usage Instructions](#usage-instructions)
- [API Documentation](#api-documentation)
  - [Firebase Authentication API](#firebase-authentication-api)
  - [Firestore API](#firestore-api)
  - [Google Maps API](#google-maps-api)
  - [Google Places API](#google-places-api)
  - [Google Gemini API](#google-gemini-api)
- [Demo Video](#demo-video)
- [App Images](#app-images)
- [Additional Resources](#additional-resources)
- [Contact](#contact)

---

## Problem Statement

Getting stranded on the road due to a vehicle breakdown or accident is a distressing experience that can escalate quickly into a life-threatening situation. Many drivers face challenges such as:
- **Lack of Immediate Assistance:** In emergencies, delays in contacting help can put lives at risk.
- **Limited DIY Knowledge:** Most drivers are not experts in vehicle repair and may struggle with simple fixes.
- **Difficulty Finding Reliable Help:** Quickly locating trustworthy mechanics, towing services, or emergency responders is challenging, especially in unfamiliar areas.
- **Communication Barriers:** In emergencies, language barriers can complicate obtaining the necessary assistance.

RoadMate addresses these issues by offering a one-stop mobile solution that provides instant troubleshooting guides, direct access to emergency services, and location-based assistance, ensuring safety and timely support for every driver.

---

## Solution Overview

RoadMate seamlessly integrates several powerful technologies to create an all-encompassing emergency roadside assistance platform:

- **Flutter App Development:** Built using Flutter for cross-platform compatibility (Android and iOS) from a single codebase.
- **Firebase Integration:**  
  - **Authentication:** Secure login system using Firebase Authentication.
  - **Firestore:** Stores user profiles and a comprehensive library of DIY tutorials and guides for common car issues.
- **Google Maps API:** Displays real-time maps and navigational assistance, showing the location of nearby mechanics, police, ambulances, and towing services.
- **Google Places API:** Retrieves details for nearby emergency service providers and support centers.
- **Google Gemini API Chatbot:** Offers an intelligent, multilingual AI-driven assistant that provides step-by-step solutions and troubleshooting advice.
- **Demo and APK:** A demo video is available on YouTube, and an APK file is provided in the repository for direct installation on Android devices.

---

## Setup & Installation

Follow these steps to set up and run RoadMate on your local machine or mobile device:

### Prerequisites

- **Flutter SDK:** Ensure you have the latest version of Flutter installed. [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
- **Firebase Account:** Although the Firebase JSON file is already included in the repo, a Firebase account is recommended for further customizations.
- **Android Studio or VS Code:** For code editing and debugging.
- **Git:** To clone the repository.

### Steps to Set Up

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/avgvcoding/RoadMate.git
   cd RoadMate
   ```

2. **Install Dependencies:**
   - Run the following command to fetch all Flutter packages:
     ```bash
     flutter pub get
     ```

3. **Firebase Configuration:**
   - The Firebase configuration JSON file is already present in the repository. No further setup is required.
   - If you wish to use your own Firebase instance, replace the existing `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) with your own.

4. **API Keys:**
   - All required API keys (Google Maps, Google Places, Google Gemini) are included in the repository.
   - Simply fork the repository and run the app without the need to add or modify your own keys.

5. **Run the Application:**
   - For Android:
     ```bash
     flutter run
     ```
   - For iOS:
     ```bash
     flutter run
     ```
   - Alternatively, use Android Studio or VS Code to run and debug the app on your emulator or connected device.

6. **APK Installation (Android):**
   - Download the [APK file](app-release.apk) from the repository.
   - Transfer the APK to your Android device.
   - Enable installation from unknown sources in your device settings.
   - Install the APK and open the app.

---

## Usage Instructions

Once RoadMate is installed, follow these steps to interact with the app:

1. **User Login & Registration:**
   - Open the app and sign up using your email. The authentication is powered by Firebase Authentication.
   - Existing users can log in directly.

2. **User Profile Management:**
   - After logging in, manage your profile information which is stored securely in Firestore.
   
3. **Access DIY Tutorials:**
   - Navigate to the tutorials section where you can view a list of troubleshooting guides and video tutorials stored in Firestore.
   - Tap on any guide to view detailed, step-by-step instructions.

4. **Map & Location Services:**
   - Use the integrated Google Maps view to locate nearby mechanics, emergency services, police stations, ambulances, and towing providers.
   - The app uses real-time location tracking to display accurate positions on the map.

5. **Emergency Assistance:**
   - In the event of an accident or a critical breakdown, use the emergency contact feature to instantly call nearby emergency services.
   - The app automatically shares your current location for a faster response.

6. **Chatbot Assistance:**
   - Interact with the built-in AI chatbot powered by Google Gemini API.
   - Ask questions in your preferred language and get immediate assistance and guidance.

---

## API Documentation

While RoadMate's primary functionalities are accessed via the Flutter front-end, the following key APIs are integrated:

### Firebase Authentication API
- **Purpose:** Handle user sign-up, login, and secure authentication.
- **Endpoints:** Managed internally by Firebase.
- **Parameters:**  
  - **Email**
  - **Password**

### Firestore API
- **Purpose:** Store and retrieve user profiles, DIY guides, and tutorials.
- **Data Structure:**  
  - **Users Collection:** Contains user profiles with fields like name, email, and contact details.
  - **Tutorials Collection:** Contains documents with detailed guides including text and video URLs.
- **Usage:** Data is fetched directly in Flutter using Firebase's Firestore package.

### Google Maps API
- **Purpose:** Display interactive maps and provide navigational support.
- **Key Features:**  
  - Real-time location tracking.
  - Display markers for service centers and emergency services.
- **Parameters:**  
  - **Latitude & Longitude Coordinates**
  - **Zoom Level**
  
### Google Places API
- **Purpose:** Retrieve details of nearby service providers such as mechanics, police, ambulances, and towing services.
- **Parameters:**  
  - **Location Coordinates**
  - **Type of Service**
  - **Radius of Search**

### Google Gemini API
- **Purpose:** Power the intelligent multilingual chatbot that provides troubleshooting assistance.
- **Functionality:**  
  - Natural Language Understanding (NLU) for user queries.
  - Provides step-by-step assistance and supports multiple languages.
  
For additional technical details and further customizations, refer to the code comments and inline documentation within the repository.

---

## Demo Video

A detailed demo video showcasing the features and functionalities of RoadMate is available on YouTube.

[Watch the Demo Video](https://youtu.be/POSViz-btZQ?si=MJz1x2YMUmxyQ_hv)

https://youtu.be/POSViz-btZQ?si=D2GxnixE1lSmA1TH

---

## App Images

<div align="center">
  <img src="https://github.com/avgvcoding/hackathon-RoadMate/blob/dd5141f7adf13ea25d78b72432c97b5c835b7eb7/App%20Images/IMG-20250323-WA0006.jpg" width="300">
  <img src="https://github.com/avgvcoding/hackathon-RoadMate/blob/dd5141f7adf13ea25d78b72432c97b5c835b7eb7/App%20Images/IMG-20250323-WA0002.jpg" width="300">
  <img src="https://github.com/avgvcoding/hackathon-RoadMate/blob/dd5141f7adf13ea25d78b72432c97b5c835b7eb7/App%20Images/IMG-20250323-WA0003.jpg" width="300">
  <img src="https://github.com/avgvcoding/hackathon-RoadMate/blob/dd5141f7adf13ea25d78b72432c97b5c835b7eb7/App%20Images/IMG-20250323-WA0004.jpg" width="300">
  <img src="https://github.com/avgvcoding/hackathon-RoadMate/blob/dd5141f7adf13ea25d78b72432c97b5c835b7eb7/App%20Images/IMG-20250323-WA0005.jpg" width="300">
  <img src="https://github.com/avgvcoding/hackathon-RoadMate/blob/dd5141f7adf13ea25d78b72432c97b5c835b7eb7/App%20Images/IMG-20250323-WA0007.jpg" width="300">
  <img src="https://github.com/avgvcoding/hackathon-RoadMate/blob/dd5141f7adf13ea25d78b72432c97b5c835b7eb7/App%20Images/IMG-20250323-WA0008.jpg" width="300">
  <img src="https://github.com/avgvcoding/hackathon-RoadMate/blob/dd5141f7adf13ea25d78b72432c97b5c835b7eb7/App%20Images/IMG-20250323-WA0009.jpg" width="300">
  <img src="https://github.com/avgvcoding/hackathon-RoadMate/blob/dd5141f7adf13ea25d78b72432c97b5c835b7eb7/App%20Images/IMG-20250323-WA0010.jpg" width="300">
  <img src="https://github.com/avgvcoding/hackathon-RoadMate/blob/dd5141f7adf13ea25d78b72432c97b5c835b7eb7/App%20Images/IMG-20250323-WA0011.jpg" width="300">
  <img src="https://github.com/avgvcoding/hackathon-RoadMate/blob/dd5141f7adf13ea25d78b72432c97b5c835b7eb7/App%20Images/IMG-20250323-WA0012.jpg" width="300">
  <img src="https://github.com/avgvcoding/hackathon-RoadMate/blob/dd5141f7adf13ea25d78b72432c97b5c835b7eb7/App%20Images/IMG-20250323-WA0013.jpg" width="300">
  <img src="https://github.com/avgvcoding/hackathon-RoadMate/blob/dd5141f7adf13ea25d78b72432c97b5c835b7eb7/App%20Images/IMG-20250323-WA0014.jpg" width="300">
  <img src="https://github.com/avgvcoding/hackathon-RoadMate/blob/dd5141f7adf13ea25d78b72432c97b5c835b7eb7/App%20Images/IMG-20250323-WA0015.jpg" width="300">
</div>

---

## Additional Resources

- **Flutter Documentation:** [Flutter Docs](https://flutter.dev/docs)
- **Firebase Documentation:** [Firebase Docs](https://firebase.google.com/docs)
- **Google Maps Platform:** [Google Maps API](https://developers.google.com/maps)
- **Google Places API:** [Google Places API](https://developers.google.com/places)
- **Google Gemini API:** [Google Gemini](https://cloud.google.com/vertex-ai) *(Check the official Google Gemini API documentation for updates)*

---


## Contact

For any queries or support, please contact:

**Aviral Gupta**  
Email: [aviral.ceo.123@gmail.com](mailto:aviral.ceo.123@gmail.com)  
Contact: +91 8299585776

---

Enjoy using RoadMate, and drive safe!
