| State            | Description                                                                                                                                                                                                                          | UI (See Screenshot/s Below)                         | Next Action                                      |
|------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------|--------------------------------------------------|
| Registration     | Users register with a username and password or sign up with new credentials through the application's registration page interface. Registered users are automatically directed to the home page and can sign out from there. | Login and Sign Up Pages   | Reserve a washing machine, join waiting list, view subscribed machines/jobs |
| Reserve Machine  | Users can reserve a washing machine from the home page by selecting from a catalog, entering a security PIN, and specifying wash intensity and duration. Delicate (10 mins), Normal (5 mins), Quick (3 mins).                          | Schedule Dialog                  | Schedule another job for available machine       |
| Subscribe        | Users join the waiting list for a machine and can view subscribed machines on dedicated pages.                                                                                                                                      | Subscribe Dialog   | -                                                |
| Job Processing | Users with scheduled jobs wait for machine activation. The job displays its info and status (e.g., wash cycle, intensity, machine status) with a progress indicator.                                                             | Jobs Page Processing   | When the machine starts we move to Job in Progress state                                                |
| Waiting List     | Users wait for a machine to become available, seeing their position in line and machine status via visualization (e.g., drum animation).                                                                                          | Subscribed in Progress   | -                                                |
| Job in Progress | Users monitor ongoing jobs, seeing a countdown timer and receiving notifications for intensity deviations or door status.                                                                                                        | Job Page Processing, Intensity Issue Notification, Door Open Notification    | When machine finishes its cycle we move to Job Finished state                                                |
| Job Finished     | Users receive notifications for job completion, with early or on-time alerts. Next person on the waiting list and scheduler also receive notifications.                                                                                 | Finish Notification   | -                                                |
| Errors           | Alert dialogs notify users of errors such as wrong PIN or credentials, or attempting to schedule a working machine.                                                                                                                 | Wrong PIN Dialog, Machine Busy Snackbar         | -                                                |
| Unsubscribe      | Users can remove themselves from the waiting list or dismiss cards on the subscribed page.                                                                                                                                         | Unsubscribe Dismiss   | -                                                |
| ESP Functioning  | The ESP continuously monitors vibration intensity.                                                                                                  | The built-in led in ON when the vibration sensor is collecting readings.            | -                                                |

## Screenshots

- **Login and Sign Up Page:**

  <img src="./app-assets/login.jpg" alt="Login Page" width="300">
  <img src="./app-assets/signup.jpg" alt="Sign Up Page" width="300">

- **Home Page:**

  <img src="./app-assets/home.jpg" alt="Home Page" width="300">

- **Schedule Dialog:**

  <img src="./app-assets/schedule_dialog.jpg" alt="Schedule Dialog" width="300">

- **Subscribe Dialog:**

  <img src="./app-assets/subscribe_dialog.jpg" alt="Subscribe Dialog" width="300">

- **Machine Metadata:**

  <img src="./app-assets/machine_metadata.jpg" alt="Machine Metadata" width="300">
  
- **Job Page Processing:**

  <img src="./app-assets/job_page_processing.jpg" alt="Job Page Processing" width="300">

- **Job Page in Progress:**

  <img src="./app-assets/job_page_in_progress.jpg" alt="Job Page in Progress" width="300">

- **Subscribed in Progress:**

  <img src="./app-assets/subscribed_in_progress.jpg" alt="Subscribed in Progress" width="300">

- **Early Finish Notification:**

  <img src="./app-assets/early_finish_notification.jpg" alt="Early Finish Notification" width="300">

- **Finish Notification:**

  <img src="./app-assets/finish_notification.jpg" alt="Finish Notification" width="300">

- **Wrong PIN Dialog:**

  <img src="./app-assets/wrong_pin_dialog.jpg" alt="Wrong PIN Dialog" width="300">

- **Machine Busy Snackbar:**

  <img src="./app-assets/machine_busy_snackbar.jpg" alt="Machine Busy Snackbar" width="300">

- **Intensity Issue Notification:**

  <img src="./app-assets/intensity_issue.jpg" alt="Intensity Issue Notification" width="300">

- **Intensity Issue Resolved Notification:**

  <img src="./app-assets/intensity_issue_resolved.jpg" alt="Intensity Issue Resolved Notification" width="300">

- **Door Open Notification:**

  <img src="./app-assets/door_open_notification.jpg" alt="Door Open Notification" width="300">

- **Unsubscribe Dismiss:**

  <img src="./app-assets/unsubscribe_dismiss.jpg" alt="Unsubscribe Dismiss" width="300">

- **Usage Dialog:**

  <img src="./app-assets/usage_dialog.jpg" alt="Usage Dialog" width="300">
