# Event Hub Flutter

### Base Idea
```
A Firebase app for 
    -finding events in institutes around you,
    -following organisers and institutes for events, 
```
### Folder Structure
* blocs -> has buisness logic components
* models -> has response data models which we will recieve
* resources -> has repository classes and network call implemented classes
* ui
    * tabs ->  user screens
    * tiles -> reusable tiles

## Caching and Storage
* GlobalBloc level:
    * eventtab list stored in eventListCache
    * eventpage documents stored in eventPageCache
* SQL
    * Stored bookmarks in SQLite 
        > Converted documentSnapshot to map, with *documentId* mapped as *id* 

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
    Login
    if(success) // tokens are of atleast 2 month validity
        yes -> 'MainScreen'
        no -> show error and try again button
                if(success) // onclick login button
                    yes -> MainScreen
3.MainScreen
    layout: Tabs as in screens section ^^


```