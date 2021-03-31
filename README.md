# Media-Finder
An application to play movies, songs or Tv-shows from iTunes Search API by using Alamofire and pars the data.<br/>
Store the user data and the last search result for each user in a database by using SQLite.<br/>
# 1- Sign Up View
It contains user name, user email, password, user image, user gender and user address.<br/>
 When the user clicks on Sign Up button<br/>
- In case he/she entered invalid data or the user data entry is not completed he/she should see an alert tell him/her what is wrong.
<br><br>

- In case he/she clicks on the image button the image picker will allow the user to pick an image from the galary when he/she choose the image the sign up view will display.
<br><br>

- In case he/she clicks on the address the map view will display and allow the user to get the address from the center location of the map then click confirm to send the address and the sign up view will display.
<br><br>

- Sign up view after getting the address and the map.
<br><br>


# 2- Sign In View
It contains user email and password.<br/>
- In case the user already has an account and he/she try to log in via Sign In screen you must validate email and password as in the database.<br/>
- In case he/she entered invalid data he/she should see an alert tell him/her what is wrong.<br/>
- In case he/she entered valid data you must check if these credentials exist on the database or not to decide to let him/her in or alert him/her with invalid credentials alert.<br/>
<br><br>


# 3- Media List View
It contains a search bar for the Media name ,Sigmented buttons to choose the type of the media (movies-songs-tv-shows) and a table view to show the result of the search.<br/>
<br/>
Examples:<br/>
- The user search for Adele of type song then choose Rolling in the deep song.
<br><br>

- The user search for xmen of type movie then choose xmen movie.
<br><br>

- The user search for xmen of type tv-show then choose xmen The Animated Seires.
<br><br>

- The user search for something with no result.
<br><br>
 

# 4-Profile
It contains the user information.
<br><br>

