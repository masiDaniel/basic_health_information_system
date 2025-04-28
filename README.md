# CEMA SYSTEM.
A heathcare information system for managing clients and health programs.


[![Build Status](https://img.shields.io/badge/build-passing-brightgreen)](#)
[![Last Commit](https://img.shields.io/github/last-commit/masiDaniel/basic_health_information_system)](#)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](#)

## Description.
This is a mobile system that easenes medical systems by ensuring that doctors can manage their patients effectively.

## Features 
- Creation of health programs.
- Registration of new clients.
- Enrolment of clients into one or more programs.
- Search functionality(Search for a client).


## Tech stack

**Frontend:** Flutter
**Backend:** Django
**Database:** Sqlite3
**Authentication:** Token

# SetUp instructions.
1. Clone the repository using the command (git clone <repository-link>)

    ## Backend.
    1. create a virtual environment using: ( python3 -m venv .venv)
    2. activate the virtual enviroment using: (source .venv/bin/activate) 
    3. install dependecies using: (pip install -r requirements.txt)
    4. cd healthBackend/
    6. Run migrations to create the database and apply all the relevant configurations using the following commands (1. python manage.py makemigrtions, 2. python manage.py migrate)
    5. start the server using: (python manage.py runserver)

    ## Frontend.
    1. Ensure that you have flutter installed in your system, if not follow this link and choose your desired platform [https://docs.flutter.dev/get-started/install]
    2. cd health_frontend/
    3. run the project using: (flutter run)
    4. Incase you get challanges setting up the flutter SDk,(we all do), head down to the postman section


    ## Postman.
    import the collection to your postman.
    1. Sign up the user first(doctor in our case) then log them in to get the token as all the remaining endpoints  require authorization, security first
    2. supply the token under the headers section (there is already one but it might be inactive)
