# Firestore Security Rules Setup

## Quick Setup (Temporary - For Development)

Go to Firebase Console → Firestore Database → Rules and paste this:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null && (request.auth.uid == userId || request.auth.token.email == 'Admin@gmail.com');
      allow create: if request.auth != null;
    }
    
    // Admins collection
    match /admins/{adminEmail} {
      allow read, write: if request.auth != null;
    }
    
    // Products collection - public read, authenticated write
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Orders collection
    match /orders/{orderId} {
      allow read: if request.auth != null && (
        resource.data.userId == request.auth.uid || 
        request.auth.token.email == 'Admin@gmail.com'
      );
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update: if request.auth != null && (
        resource.data.userId == request.auth.uid ||
        request.auth.token.email == 'Admin@gmail.com'
      );
    }
  }
}
```

## Steps:
1. Go to https://console.firebase.google.com/
2. Select your project: `bigbasketclass`
3. Go to Firestore Database → Rules tab
4. Paste the rules above
5. Click "Publish"

**Note:** For production, you should implement more strict rules and proper admin verification.

