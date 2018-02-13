# MAD-2018
HHS Mobile App Development

*By Eric Cheng, David McAllister, and Lily Li*

View the most recent ReadMe with image-filled installation instructions: https://github.com/Eric-Cf/MAD-2018/wiki

This app is designed to provide a mobile interface that works alongside a stable backend database structure to provide users with information about available books, their holds, and their checkouts. Additionally, it implements a scanner API to allow users to checkout books with their phone cameras. The app was developed in conjunction with Homestead High School's library to ensure our app would be useful in a real world situation.

## Getting Started

Download Xcode to run the testing environment. You can view the code, but you need a developer account to sign the instance to run on your computer. 
Alternatively, you can download the app off of "TestFlight" onto your phone to run the app on your phone.

### Prerequisites

To view the code
```
-Mac OS
-XCode
-Alternative Swift IDE (i.e. AppCode for Mac OS, text editor like Atom or SublimeText on Windows)
```
To run the application on your computer
```
-Mac OS
-XCode
-Developer signing 
```

### Installation and Use

A step by step series of how to run our project assuming prerequisites are met.

1. Open Xcode and select "Open another project..."
2. Locate the submission folder and enter the MAD folder inside, clicking on the white MAD.xcworkspace file
![proj2](https://user-images.githubusercontent.com/26942890/36134916-905621ee-103c-11e8-9621-bcb171868d55.png)
3. After clicking open, click on the uppermost blue MAD file. You may see some red errors.
![proj3](https://user-images.githubusercontent.com/26942890/36134969-dc8501b6-103c-11e8-9f1c-d5ca45dbf508.png)
4. Change the provisioning profile to your own developer account.
![proj4](https://user-images.githubusercontent.com/26942890/36134994-086cf360-103d-11e8-93b8-e301b817adca.png)
5. It may say “Failed to create provisioning profile.”
![proj5](https://user-images.githubusercontent.com/26942890/36135007-1d194c96-103d-11e8-9f75-c50c5a08c301.png)
6. Edit the bundle identifier by adding a number to the end and click “Try Again.”
![proj6](https://user-images.githubusercontent.com/26942890/36135146-285446a0-103e-11e8-806c-633dc165cd75.png)
7. You can now view all the classes and storyboards that go into the application.
8. [Make sure xcode is opening a simulator of a valid and modern iPhone.]
![proj8](https://user-images.githubusercontent.com/26942890/36135164-3fcf4f0a-103e-11e8-9202-9f1eb4d07472.png)
9. To directly download the app onto your phone, plug your own phone into the computer and select your phone to download the app on your phone. You may have to approve the application on your iPhone.
10. After the application opens, log in with school id “1234567” and password “test.”
11. Feel free to browse the app!
The scanner portion of the app only works on an actual phone where a camera can be accessed.
12. You can log in with facebook within the *Onboarding Pages* or the *Profile Page*. Please use the following login information to see how our app uses facebook friend systems to enhance user experience.
* Email: dmcallister452@student.fuhsd.org
* Password: fblaJudgeLogin
![img_5589](https://user-images.githubusercontent.com/26942890/36135024-3baa4cb4-103d-11e8-9bbd-3068dd2de9d1.PNG)
Onboarding Page On First Launch

13. Below is an example barcode to be used with the scanner.  We encourage you to test it on books around your home or office as well!

![barcode](https://user-images.githubusercontent.com/26942890/36134449-b9bf6b56-1039-11e8-91f7-18aed490d548.gif)

14. If you ever run into any issues, submit a bug report at the bottom of the "My Books" page.

## Key Features

* Robust backend relational database to store information
* Book barcode scanner using RESTful APIs to generate book information
* Well commented database access code
* Checkout with your phone for ease of access
* Intelligent keyword search algorithm to look for books
* Hold system that lets you reserve a book to pick up later
* Customized map to identify book locations
* Bug reporting to enable continuous development
* Smart resource management to reduce database calls and memory leaks
* Facebook integration to allow for a social aspect to our application

## Database Structure

Database is a relational MySQL database running the InnoDB engine. It uses various foreign key checks to ensure the integrity of the data and eliminate potential errors in database calls.
[You can see our design schema here](https://eric-cf.github.io/MAD-2018/) 

## Deployment

This application is supported by a server side script, so any user just has to connect with their account (made with the library when they join the school)

## Built With

* MySQL server hosted with bluehost.com
* PHP access code hosted with bluehost.com
* Swift code for UI and implementation
* CocoaPods for library dependency management
* Lottie by Airbnb for in-app animations
* Adobe Photoshop CC for app graphics
* XCode Integrated Development Environment

## Authors

* **Eric Cheng** - *Database and Backend* - [Eric-Cf](https://github.com/Eric-Cf)
* **David McAllister** - *UI design and Implementation* - [mcallisterdavid](https://github.com/mcallisterdavid)
* **Lily Li** - *Login and Code Deployment* - [lilyli333](https://github.com/lilyli333)

## License

This project is licensed under the GNU Lesser General Public License v3.0 - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Thanks to Stanford Mobile App Development course for iOS app development learning resources
* Thanks to Mr. Kuramoto, the San Mateo Library branch manager, for answering our questions about library operations
* Thanks to Mr. Shelby, former computer engineer, for giving us feedback on user testing
* Special thanks to Mrs. Amity Bateman for answering our questions on what features Homestead High School wanted most from a library app

## Copyright Information

* Book information and cover images powered by Google Books, labeled within the app consistent with their API usage policies
* Facebook logo used for application graphics with explicit permission from the Facebook Brand Resource Center
* Google logo used for application graphics in accordance with trademark usage guidelines available [here](https://www.google.com/permissions/trademark/rules.html)
* Photo of Homestead High School cafeteria and horse statue provided by the Homestead High School Epitaph
* Following image acknowledgements are consistent with the [Freepik terms of use](freepik.com/terms_of_use)
* ["Boxing day sale background"](https://www.freepik.com/free-vector/boxing-day-sale-background_1442395.htm) image designed by [Freepik](freepik.com)
* ["Safety lock logo"](https://www.freepik.com/free-vector/safety-lock-logo_717950.htm#term=lock%20icon&page=1&position=9) image designed by [Freepik](freepik.com)
* ["Colorful books pack"](https://www.freepik.com/free-vector/colorful-books-pack_813860.htm#term=book&page=1&position=2) image designed by [Freepik](freepik.com)
* All other images and icons are completely original


