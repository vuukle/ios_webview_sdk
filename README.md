
'Vuukle' iOS SDK framwork works with Objective-C and Swift 3.0 (or greater)

 • Home page [Vuukle]("https://vuukle.com/")

## INSTALLATION 
-----------------------------------------------------------------------------------------

[0. Create Podfile for your Project] You can skip this step, if you already have Podfile

  # Open terminal and change default directory to your project directory.
    -> Run command 'cd [your project path]' (EXAMPLE: 'cd /Users/fedir/Desktop/ExampleProject')
    
  # Create Podfile.
    -> Run command 'pod init' and wait for completion

  # Open Podfile in Xcode.
    -> Run command 'open -a Xcode podfile'

[1. Add pod 'Vuukle' to list of pods] 

  # If you have just created new Podfile, add following lines of code to it (replace 'ExampleProject' with yor project name).

    platform :ios, '9.0'
     
    target '[your project name]' do

      use_frameworks!
      pod 'Vuukle'

    end

  # If you already have Podfile simple add Vuukle to list of your pods.
    
    pod 'Vuukle'

  # [!] For OBJECTIVE-C you should define version of Swift after target end.

    target '[your project name]' do
       ...
    end

    post_install do |installer|
      installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|

          config.build_settings['SWIFT_VERSION'] = '3.0'

        end
      end
    end


[2. Install pods for Project] 

  # Close your project 
    • EXAMPLE: If you have opened ExampleProject.xcodeproj, close it. After installation of pods you will work with ExampleProject.xcworkspace

  # (If you closed terminal after step 0.) Open terminal again and change default directory to your project directory.
    -> Run command 'cd [your project path]' (EXAMPLE: cd /Users/fedir/Desktop/ExampleProject)

  # Install pods for Project.
    -> Run command 'pod install' and wait for completion
    
    This command will install latest version of pod 'Vuukle' and dependency pods: 

    • 'Alamofire'      (version >= 4.3.0)
    • 'AlamofireImage' (version >= 3.2.0) 
    • 'MBProgressHUD'  (version >= 1.0.0)
    • 'NSDate+TimeAgo' (version >= 1.0.6)

[3. Please add to info.plist next parameter]

  Select info.plist in your project and add "App Transport Security Settings" and change type "String" to
  "Dictionary". Then add to "App Transport Security Settings" - Allow Arbitrary Loads type "Boolean" value
  "YES". 
  http://stackoverflow.com/questions/31254725/transport-security-has-blocked-a-cleartext-http

## IMPORT SWIFT
-----------------------------------------------------------------------------------------
[4. Add Vuukle to Embedded Binaries] 

  # Open generated after installation .xcworkspace file.
    • EXAMPLE: In project directory open ExampleProject.xcworkspace 

    You can also run using terminal:
      -> Run command 'cd [your project path]' (EXAMPLE: cd /Users/fedir/Desktop/ExampleProject)
      -> Run command 'open ExampleProject.xcworkspace'

  # Open your project settings.
    Tap on your project in project navigator (in top left corner)

  # Add Vuukle to Embedded Binaries
    • Select 'TARGETS' and scroll down to 'Embedded Binaries'
    • Tap on '+' button and select 'Add Other...'
    • Go to 'Pods -> Vuukle -> Vuukle' and select 'Vuukle.framework' file

[5. Import Vuukle] 

  # Simple add 'import Vuukle' in the top of .swift file after other framworks your use.

    • EXAMPLE: 
   
    import UIKit
    import Vuukle

    class ExampleViewController: UIViewController {
    ...


## IMPORT OBJECTIVE-C
-----------------------------------------------------------------------------------------
[6. Open workspace and import Vuukle] 

  # Open generated after installation .xcworkspace file.
    EXAMPLE: In project directory open ExampleProject.xcworkspace 

    You can also run using terminal:
    -> Run command 'cd [your project path]' (EXAMPLE: cd /Users/fedir/Desktop/ExampleProject)
    -> Run command 'open ExampleProject.xcworkspace'

  # Open your project settings.
  Tap on your project in project navigator (in top left corner)

  # Add Vuukle to Embedded Binaries
  • Select 'TARGETS' and scroll down to 'Embedded Binaries'
  • Tap on '+' button and select 'Add Other...'
  • Go to 'Pods -> Vuukle -> Vuukle' and select 'Vuukle.framework' file

[7. Import Vuukle] 

  # Simple add '#import <Vuukle/Vuukle-Swift.h>' before @interface in .m file.

  • EXAMPLE: 

  #import <Vuukle/Vuukle-Swift.h>

  @interface ViewController ()
    ...
  @end
 
  @implementation ViewController
    ...


## USAGE SWIFT: 
-----------------------------------------------------------------------------------------

[8. Add vuukle comments to conent view for it]
  
   # [!] You have add comments in this method of UIViewController:

   override func viewWillAppear(_ animated: Bool) {
     ...
   }

   # For nested comments (hold 'Alt' and click on method in Xcode to see more details):
   
   VUCommentsBuilder.addVuukleComments(baseVC: [Your view controller],
                                       baseScrollView: [Your main scroll view],
                                       contentView: [Your content view for vuukle],
                                       contentHeightConstraint: [Your content view height constraint],
                                       appName: [App name],
                                       appID: [App bundle ID],
                                       vuukleApiKey: [Vuukle api key],
                                       vuukleSecretKey: [Vuukle secret key],
                                       vuukleHost: [Vuukle host],
                                       vuukleTimeZone: [Your Time Zone],
                                       articleTitle: [Article title],
                                       articleID: [Article ID)],
                                       articleTag: [Article tag],
                                       articleURL: [Article URL])


   # For own comments scroll (hold 'Alt' and click on method in Xcode to see more details):
   
   VUCommentsBuilder.addVuukleComments(baseVC: [Your view controller],
                                       contentView: [Your content view for vuukle],
                                       appName: [App name],
                                       appID: [App bundle ID],
                                       vuukleApiKey: [Vuukle api key],
                                       vuukleSecretKey: [Vuukle secret key],
                                       vuukleHost: [Vuukle host],
                                       vuukleTimeZone: [Your Time Zone],
                                       articleTitle: [Article title],
                                       articleID: [Article ID)],
                                       articleTag: [Article tag],
                                       articleURL: [Article URL], 
                                       isScrollEnabled: true,
                                       edgeInserts: [Edge insrest for comments])



[9. Update all heights]

  # [!] You have update all hights in this method of UIViewController:
  
  override func viewDidAppear(_ animated: Bool) {
    ...
  }

  # To update height call method

  VUCommentsBuilder.updateAllHeights()


  # If you app supports landscape orintation, you have to call this method after rotation.
 
  • EXAMPLE: 

  override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
    VUCommentsBuilder.updateAllHeights()
  }

[10. LogIn through your application]

  VUCommentsBuilder.loginUser(name: [Your name], email: [Your email])

  VUCommentsBuilder.logOut()

[11. Everything is ready, you can run the Project]
