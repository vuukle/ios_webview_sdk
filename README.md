This library works with Swift and Objective-C.

1.Install the library to your project.
Example Podfile - Swift (If Xcode version is less than 8.0):


        platform :ios, '9.0'

        use_frameworks!


            target ‘My Project Name’ do
            use_frameworks!

            pod ‘Vuukle’, :git => 'https://github.com/vuukle/vuukle_iOS_SDK.git', :branch => ‘master’ 

        end
------------------------------------------------------------------

Example Podfile - Objective-c (If Xcode version is less than 8.0): 

        platform :ios, '9.0'

        use_frameworks!


            target ‘VuukleCommentObjective’ do

            pod ‘Vuukle’, :git => 'https://github.com/vuukle/vuukle_iOS_SDK.git', :branch => ‘master’

        end
_________________________________________________________________
Example Podfile - Swift (If Xcode version is higher than 8.0):


        platform :ios, '9.0'

        use_frameworks!


            target ‘My Project Name’ do
            use_frameworks!

            pod ‘Vuukle’, :git => 'https://github.com/vuukle/vuukle_iOS_SDK.git', :branch => ‘swift_3’ 

        end

    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end
------------------------------------------------------------------

Example Podfile - Objective-c (If Xcode version is higher than 8.0): 

        platform :ios, '9.0'

        use_frameworks!


            target ‘VuukleCommentObjective’ do

            pod ‘Vuukle’, :git => 'https://github.com/vuukle/vuukle_iOS_SDK.git', :branch => ‘swift_3’

        end

    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end
_________________________________________________________________

2.Import "Vuukle" framework into your "YourController.swift"
For example (Swift):

import Vuukle
-----------------------------------------------------------------
For example (Objective-c):

#import <Vuukle/Vuukle-Swift.h>

3.Add all "VuukleCommentsBuilder" methods into "viewDidLoad()"

For example (Swift):

@IBOutlet weak var someView: UIView!

override func viewDidLoad() {
super.viewDidLoad()

        let vuukle = VuukleCommentsBuilder()
        vuukle.firstVuukleTag("articleTag1")
        .setVuukleApiKey("777854cd-9454-4e9f-8441-ef0ee894139e")
        .setVuukleArticleId("00048")
        .setVuukleArticleTitle("myArticleTitle")
        .setVuukleEmoteVisible(true)
        .setVuukleHost("your_host")
        .setVuukleSecretKey("07115720-6848-11e5-9bc9-002590f371ee")
        .setVuukleTimeZone("Europe/Kiev")
        .setVuukleTitle("Title")
        .setAppName("myAppName")
        .setArticleUrl("myArticleUrl")
        .setAppID("myApId")
        .setVuukleRefreshVisible(true)
        .addWebViewArticleURL(false)
        .setScrolingVuukleTableView(true)
        .buildVuukle(self.view)
}
----------------------------------------------------------------
For example (Objective-c):

- (void)viewDidLoad {
[super viewDidLoad];


VuukleCommentsBuilder *builder = [VuukleCommentsBuilder new];

    [[[[[[[[[[[[[[[[builder firstVuukleTag:@"articleTag1"]
            setVuukleApiKey:@"777854cd-9454-4e9f-8441-ef0ee894139e"]
            setVuukleArticleId:@"00048"]
            setVuukleEmoteVisible:YES]
            setVuukleHost:@"your_host"]
            setVuukleSecretKey:@"07115720-6848-11e5-9bc9-002590f371ee"]
            setVuukleTimeZone:@"Europe/Kiev"]
            setVuukleTitle:@"Title"]
            setAppName:@"myAppName"]
            setArticleUrl:@"myArticleUrl"]
            setAppID:@"myApId"]
            setVuukleArticleTitle:@"myTitle"]
            setVuukleRefreshVisible:YES]
            addWebViewArticleURL:NO]
            setScrolingVuukleTableView : YES]
            buildVuukle:self.view];

}

4.Please add into "Info.plist" fields with values

For example :

App Transport Security Settings  Dictionary  (1 item)
Allow Arbitary               Boolean     YES


5.Everything is ready, you can run the project.

___________________________________________________________________

                    Information about parameters:

1. setVuukleEmoteVisible(true)                                -[Set true for visible emote rating!]Optional field.(Bool value)

2. setVuukleAdsVisible(true)                                  -[Set true for visible Ads!]Optional field.(Bool value)

3. setVuukleRefreshVisible(true)                              -[Set true for visible refres!] Optional field.(Bool value)
 
4. addWebViewArticleURL(false)                                [Set true for visible your WebContent from Aticle URL!]Optional field.(Bool value)

5. setScrolingVuukleTableView(true)                           -[Set true for the possibility of scroll Vuukle Table View! For example: If you need to add a Vuukle comments on Scroll View near your content,set false!]Optional field.(Bool value)

6. setVuukleArticleId("00000")                                -[Get id from Vuukle site. Every article has unique id!] Required field ! (String value)

7. setVuukleHost("your_host")                                 -[Set host for Api. Host - this is domain of the publisher’s              site(e.g. indianexpress.com, thehindu.com etc.).
                                                              For example: You are the owner of indianexpress.com and have own app where want’s to setup this library,so when library installed on your app, You should paste domain for ‘host’ property without http:// or https:// or www.] Required field !(String value)

8. setVuukleApiKey("00000000-0000-0000-0000-0000000000")      -[Set your API key for API. To get API KEY you need :
                                                               1) Sign in to dashboard thouth vuukle.com
                                                               2) Navigate to domain from home page of dashboard (first page after signing in)
                                                               3) Choose in menu Integration, then API Docs from the dropdown
                                                               4) Then you will be able to see API and secret keys]
                                                            ______________
                                                                  or
                                                            ______________

                                                               [1) Sign in to dashboard thouth vuukle.com
                                                                2) after signing in, in header you can find ‘Integration’ click -> choose API docs in the drop-down.] Required field ! (String value)

9. setVuukleSecretKey("00000000-0000-0000-0000-0000000000")   -[Set your API key for API. To get SECRET KEY you need :
                                                                1) Sign in to dashboard through vuukle.com
                                                                2) Navigate to domain from home page of dashboard (first page after signing in)
                                                                3) Choose in menu Integration, then API Docs from the dropdown
                                                                4) Then you will be able to see api and SECRET keys]
                                                            ______________
                                                                  or
                                                            ______________

                                                                [1) Sign in to dashboard thouth vuukle.com
                                                                2) after signing in, in header you can find ‘Integration’ click -> choose API docs in the drop-down.] Required field ! (String value)

10. setVuukleTimeZone("Europe/Kiev")                           -[Timezone from this resource:
                                                                <url>https://en.wikipedia.org/wiki/List_of_tz_database_time_zones</url>] Required field! (String value)
11. firstVuukleTag("your_tag")                                 -[First Tag will be unique for each page where comment box opens.

                                                                These properties You need to fill by yourself.

                                                                For example: You are on the main app page with articles list ->
                                                                you are choosing article ->
                                                                it opens and our library should have unique properties
                                                                for each article like URL, TAGS, TITLE.]

12. setVuukleArticleTitle("your_ArticleTitle")                 -[Set your Article Title.] Required field ! (String value)

13. setAppName("your_AppName")                                 -[Set your article url.] Required field ! (String value)

14. setAppID("your_ApId")                                      -[Set your application id.] Required field ! (String value)

15. setVuuklePaginationCount(10)                               -[By default, 10 items!] Optional field! (Int value)

16. buildVuukle(self.view)                                     -[Set your View name where should be displayed Vuukle!For example: "myView".] Required field!

__________________________________________________________________
                                
                                                 API


1. VuukleInfo.getCommentsCount()                               -Returns count of comments under your article (Int value)
2. VuukleInfo.getCommentsHeight()                              -Returns height of Vuukle comments block  (CGFloat value)


