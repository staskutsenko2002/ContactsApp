# ContactsApp
Technical Test for Lydia

Hello dear reviewers 👋

I present you a technical task ContactApp. The project is done completely in Swift and UIKit framework, using layout in code. Application includes all the features mentioned in the test description.

Enjoy the review 😊

## Estimation
Initial estimation is 10 hours.
Time spent is 8 hours.

## Architecture
For the architecture, I used MVVM-C + Clean Architecture.

Note: I did not create packages purposely, I used folders instead, because the project is small and I wanted to save some time. But I still wanted to demonstrate knowledge of Clean Architecture and its component.

Repository manages the logic of fetching the contacts, saving them to the local storage and using stored contacts if there is a problem with connection.

## Local Storage / Offline Mode
For local storage, I used CoreData.

## Packages
For saving time purposes, I used SDWebImage package for image caching.
This package is well supported and also has intergration with SwiftUI. So, if one day the project is moved to SwiftUI, there is no need to change the lib.

## UI
As the UI for the app, I chose a Apple native UI style, because I find simple, but clear and user-friendly at the same time.

## Contacts List
List of the contacts with pagination (infinity scroll) and a pull to tefresh functionality.

Logic of the screen:
If there is no connection and no contacts in storage, then we show error message.
If there is no connection, but there are contacts in storage, then we show stored contacts.
If there is a connection, then we show fetched contacts and we save them to local storage.

<img src="https://github.com/user-attachments/assets/e3601a14-3248-4908-896b-dd4bd98ade1b" width=300/>

## Contact Details
For this screen I used tableView as well. Here you can see the details of the contact, such as photo, name, phone, email, location, address , gender, nationality.
By clicking the phone or cellPhone cells you can call the contact 📱
By clicking the email cell you can compose the email to this contact 📩
By clicking the location cell you can see the location of the contact in the Maps app 🗺️

<img src="https://github.com/user-attachments/assets/97114ccf-3036-4a40-b0a5-cd37bf290fbc" width=300/>

## Conclusion
Thank you for checking this and reviewing my work 😁 👍
If you have any questions please contact me email: kucenko.s@icloud.com 📩

Best regards, Stanislav Kutsenko
