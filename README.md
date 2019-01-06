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
2.SplashScreen
    show loading bar initially
    if(has valid token in db) // tokens are of atleast 2 month validity
        yes -> 'MainScreen'
        no -> show login button
                if(success) // onclick login button
                    yes -> MainScreen
                    no -> display error
3.MainScreen
    layout: Tabs as in screens section ^^

    


```