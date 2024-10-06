# Mobile proof of delivery capture app
Introduction 

This document designs a simple mobile app, created for a manufacturing company ‘FCARCHITECTURAL’, in which employees such as delivery drivers or shop floor workers can scan documents (invoices, delivery notes or job sheets) and upload them to the company's existing backend server.  

The goal of this project is to build a simple to use app which focuses on core functionality, intuitive graphical user interfaces and ease of use.  

We are focused on keeping the design as simple as possible, while still addressing scalability. 

Requirements  

Users can login using an email (which must be verified via an email confirmation) and password. 

Users can scan paper documents and edit them once scanned. 

Scanned documents will be transcoded to pdf format. 

Users can save scanned pdfs. 

Users can view a list of scanned documents which they can remove if they are no longer needed. 

Users can view saved pdfs. 

Users can upload scanned pdfs to the backend server.  

Detailed Design  

Users sign up (Firebase Auth) 

Users will log in with their email addresses and passwords. The Firebase authentication SDK provides methods to create and manage users that use their email addresses and passwords to sign in. Firebase authentication also handles sending verification emails if a user has not verified their email, password reset emails and creating of new accounts.  

Firebase Auth is mainly integrated into the client code and in this case will be in the flutter app. 

PDF storage (cache) 

Initially, once a user has finished scanning documents they are stored as jpeg files in the app’s cache directory temporarily. This is done by creating a dynamic array of string paths for each scanned document and then appending them to the array. To turn the array of jpeg files into a pdf we use the flutter ‘pdf’ library. Firstly, we iterate over the array of jpeg files and use the ‘.readasBytesSync’ method which synchronously reads the entire file contents as list of bytes next, we use the ‘.writeAsBytes’ method to write the list of bytes to the pdf page. 

PDF storage (disk) 

 To allow PDF’s to be stored permanently until the user removes them, the image files are transcoded to PDF format and then stored on the devices disk using the ‘shared_preferences’ library. This library allows us to access the app’s shared preferences directory on the C: drive. Additionally, this library supports primitive data types such as strings which is perfect for our JPEG image file paths thus allowing for saved PDF’s to still be accessible even if the app is closed or crashes.   

Cloud Storage 

Firebase Cloud Storage is the chosen solution for storing all scanned PDF files from multiple users simultaneously. It offers several key advantages, making it an ideal choice for this project. First, its scalability supports vast amounts of data, handling petabytes of storage without performance issues. Second, it provides robust security through customizable declarative rules, ensuring that only authorized users—such as authenticated users—can upload files. Finally, Firebase’s resiliency ensures uploads are stable, even with poor network conditions. The process pauses if the connection drops and automatically resumes when the network improves, ensuring reliable data transfers. 

Firebase Cloud Storage operates on a Google Cloud infrastructure, making it highly reliable and fast. It integrates seamlessly with Firebase Authentication, allowing developers to specify which users can access certain files. Data is stored in regional buckets for best performance, and files can be accessed via generated download URLs. Additionally, Firebase supports various operations such as file compression, metadata handling, and automatic backups, all while offering robust monitoring and analytics through its console. 

 

References 

Firebase Auth: https://firebase.google.com/docs/auth 

Firebase Storage: https://firebase.google.com/docs/storage 

Shared_preferences: https://pub.dev/packages/shared_preferences 

