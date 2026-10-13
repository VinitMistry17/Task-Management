# Task Manager (Flutter)

A simple task management app for gig workers.

## Features
- Email/password registration and login (Firebase Authentication) with error messages
- Create, edit, delete and view tasks (title, description, due date, priority)
- Mark tasks complete / incomplete
- Filter by priority and status; list sorted by due date (earliest first)
- Per-user data stored in Cloud Firestore, with security rules
- Material 3 UI, responsive layout

## Tech
Flutter, Riverpod, Firebase Auth, Cloud Firestore

## Architecture
Feature-first structure with light layering (data / presentation):

lib/
  core/
  features/
    auth/   (repository, controller, auth gate, login/register page)
    tasks/  (model, repository, providers, list page, form page, widgets)

Firestore calls live only in repositories; UI reads state through Riverpod providers.
I chose this over full clean architecture because it fits the scope of the app.

## Run locally
1. flutter pub get
2. Create a Firebase project, enable Email/Password auth and Firestore
3. flutterfire configure
4. flutter run

## Firestore rules
Each user can only read/write documents under users/{uid}/tasks.

## APK
<Google Drive link>