# WalE
As a user, I want to see the Astronomy Picture of the Day, so that I can learn new things about our Universe everyday.

Story Description:
NASA releases the Astronomy Picture of the Day everyday. This is accompanied by the title of the picture and a short explanation of about it.

Demo Screenshot is available

api_key - 7bepocc6QPZ1btzXU4dgyrwTMswMyQkbgOCPo9d5

Base url
https://api.nasa.gov

APOD api-url
https://api.nasa.gov/planetary/apod?api_key=7bepocc6QPZ1btzXU4dgyrwTMswMyQkbgOCPo9d5

Improvement Areas
We can show the date on the UI, so that user can know for which day this info is about if internet issue exists.
We have HD image from the api, we could even show bigger resolution image.
Unable to write tests for the code written
Have not verified the app on actual device or iPad.

Trade-Offs
As picture is only for that particular day, and date is from the server. We are not able to test it for the next and verify the logic for showing same data for next day or new data is visible.
Logic to check for today's date is implemented



