# Silly Transitions

I needed to figure out some things about UIKit custom transitions so I put
together the this sample project.  Things are compartmentalized in a way that it
should be relatively easy to use in your own project or add your own
transitions.  This code only covers navigation transitions.

## Watch it

http://youtu.be/yLziqn_lK8I

## Usage

1. Add everything that's not the demo to your project.

2. Whenever you create a new navigation controller you want to use it in, call
   `[[BKNTransitioningDelegate sharedDelegate] manageNavigationController:navigationController]`

3. Before transitioning to a view controller, assign a custom transition:
   `[segue.destinationViewController setBKN_introTransitionType:BKNSillyTransitionTypeStar];`

## Defining new transitions

1. Create a new transition that conforms to `<BKNSillyTransition>`.  If you
   already have a `UIPercentDrivenInteractiveTransition` you're 90% of the way
   there.

2. Define a `BKNSillyTransitionType` value for it.

3. Add a case for it in `-[BKNTransitioningDelegate navigationController:animationControllerFor...]`.

## What I've learned

1. `UIPercentDrivenInteractiveTransition` works by kicking off an animation,
    freezing the container view's layer (`speed == 0`) and adjusting it's
    `timeOffset`.  This means it will work for animations staged with one
    animation but probably not if you chain animations with a `complete:` block.

2. `UIPercentDrivenInteractiveTransition` does not handle completion animation
   for pure CoreAnimation animations, just advancing to the beginning or end
   depending on if you finish or cancel.  I assume the internal design leans
   heavily on some UIKit code for the harder parts of configuring completion.
   I've included `BKNPercentDrivenInteractiveTransition` based on
   [stringcode86/UIPercentDrivenInteractiveTransitionWithCABasicAnimation](https://github.com/stringcode86/UIPercentDrivenInteractiveTransitionWithCABasicAnimation)
   to handle the basic case of completionSpeed = 1, linear curve.

3. There is sometimes a screen update between when the animation completes and
   the completion block is called, causing the UI to flash when the CAAnimation
   is removed. This can be avoided by not removing the animation and including
   both ends in the fill mode:

   ```ObjC
   pathAnimation.fillMode = kCAFillModeBoth;
   pathAnimation.removedOnCompletion = NO;
   ```

   You have to use both and not `kCAFillModeForwards` in this case because
   animations can reverse.  You also can't just set the property to the final
   value for the same reason.

4. If your navigation delegate responds to
   `navigationController:animationControllerFor...`, the navigation controller
   will use the default back swipe gestures.  Worse, there is no exposed
   functionality for getting it back.  I've included a hack solution based on a
   [StackOverflow answer](http://stackoverflow.com/a/20923477/860000) but it
   subverts other internal checks to work and could have unpredictable results.
   You may be best off going 100% custom.

5. It is often a lot easier to deal with CoreAnimation key paths than try
   animating the whole property. (e.g. `@"startPoint.x"` vs `@"startPoint"`.)

## Things that could improve

1. There's probably no reason to create a new instance of a transition each
   time.  It's not that expensive but they should be reusable.

2. I could expose the transitions themselves rather than the enumeration.

3. Support tab view controllers, modal view controllers.

4. Additional gestures.

5. Actual meaningful transitions between two known view controllers.
