# IdeaBarrel
Gamified idea management solution developed for internal use at Nokia
### Notes for contributors
Most CI issues can be avoided by running `dart fix --apply` and `flutter format .` before pushing your commits to GitHub.
If you want to make sure it will pass, run:

`flutter format --set-exit-if-changed .`

`flutter analyze .`

`flutter test`

`flutter build apk`

If all four finish with no errors you're good to go!
