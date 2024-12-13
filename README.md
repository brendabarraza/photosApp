# Image Sharing App for iPhone and iPad

## Description
This application is an image sharing app developed in Swift for iPhone and iPad. The app enables users to register, log in, and perform CRUD operations on images. Users can like any image and manage their profile, including viewing their uploaded images. The app features views for Home, Profile, Upload, and Likes.

## Features
- **User Authentication**:
  - User registration and login using Firebase Authentication.
  - Session persistence implemented with `UserDefaults`.

- **CRUD Operations**:
  - Users can upload, edit, and delete their own images.
  - Images are managed in Firebase Firestore and Firebase Storage.

- **Image Likes**:
  - Users can like any image and view their liked images in the Likes view.

- **User Profile**:
  - Dedicated Profile view where users can see and manage their uploaded images.

- **Home Feed**:
  - Displays all images uploaded by all users.

- **Responsive Design**:
  - Optimized for both iPhone and iPad devices.

## Dependencies
- **Firebase**:
  - Firebase Authentication for user registration and login.
  - Firebase Firestore for storing image metadata.
  - Firebase Storage for storing uploaded images.

## Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/brendabarraza/photosApp.git
   ```

2. Open the project in Xcode:
   ```bash
   cd photosApp
   open crudApp.xcworkspace
   ```

3. Install dependencies using CocoaPods:
   ```bash
   pod install
   ```

4. Configure Firebase:
   - Add your `GoogleService-Info.plist` file to the project.

5. Run the app on a simulator or a real device:
   ```
   Select the target device and press the Run button in Xcode.
   ```

## Usage
1. **Register or Log In**:
   - New users can register with an email and password.
   - Existing users can log in to access their account.

2. **Upload an Image**:
   - Navigate to the Upload view and select an image from your device.
   - Provide optional metadata and submit the image.

3. **Edit or Delete an Image**:
   - Access your uploaded images in the Profile view.
   - Select an image to edit its details or delete it.

4. **Like Images**:
   - Browse the Home view and like images by tapping the like button.
   - View all your liked images in the Likes view.

5. **Manage Profile**:
   - View and manage all your uploaded images in the Profile view.

## Project Structure
- **Views**:
  - `HomeView`:
    Displays all uploaded images.
  - `ProfileView`:
    Displays images uploaded by the logged-in user.
  - `UploadView`:
    Allows users to upload new images.
  - `LikesView`:
    Displays images liked by the user.

- **Models**:
  - `ImageModel`:
    Represents an image object with metadata.

- **Services**:
  - `FirebaseService`:
    Handles Firebase Authentication, Firestore, and Storage operations.

- **Utilities**:
  - `UserDefaultsManager`:
    Manages session persistence.

## Requirements
- Xcode 14.1 or later
- iOS 14.0 or later
- CocoaPods

## Known Issues
- Ensure you have a stable internet connection as the app relies on Firebase services.

## License
This project is licensed under the [MIT License](LICENSE).

---

## Figma Prototype

You can view the Figma prototype of the app [here](https://www.figma.com/proto/aCtVNm5U7a7kZBKAJvdYQa/Untitled?node-id=21-132&node-type=canvas&t=JXzKPO1V5GT5zesk-1&scaling=scale-down&content-scaling=fixed&page-id=5%3A12&starting-point-node-id=21%3A132).





