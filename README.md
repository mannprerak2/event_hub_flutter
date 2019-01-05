# Event Hub Flutter

### Base Idea
```
A facebook api based app for 
    -finding events in institutes around you,
    -following organisers and institutes for events, 
```
### Folder Structure
* blocs -> has buisness logic components
* models -> has response data models which we will recieve
* resources -> has repository classes and network call implemented classes
* ui -> user screens

## Screens

* Login screen----------------( with facebook only )
* MainScreen----------------( 5 tabs at bottom, content area, top bar )
    * Events Tab----------------( All events from following colleges first and then others )
    * Subscription Tab----------------( Events from subscriptions only)
    * Discover Tab----------------( Manage what you follow )
    * Saved Tab----------------( Saved things ) 


## App Flow

```
1.Start -> SplashLoaderScreen
2.SplashLoaderScreen
    if(has valid token in sharedprefs)
        yes -> MainScreen
        no -> LoginScreen 
3.LoginScreen
    if(success)
        yes -> MainScreen
4.MainScreen
    layout: Tabs as in screens section ^^

    


```