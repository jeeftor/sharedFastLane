To use this "stuff" with yoru fastlane add 

```ruby
import_from_git(url: 'https://github.com/jeeftor/sharedFastLane',
               path: 'fastlane/Fastfile')
```

##Custom Actions

###`alphaStamp`

```ruby
alphastamp
```

###`betaStamp`

```ruby
betastamp
```

###`figlet`

```ruby

figlet(text: "HELLO")

filet(text: "WHATEVER", font: "A FONT NAME")
```

###`version_from_last_tag`

returns the version from last git tag - its kinda nifty!