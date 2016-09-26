
#import "ExampleWebViewVC.h"
#import <Vuukle/Vuukle-Swift.h>

@interface ExampleWebViewVC () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *vuukleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vuukleHeightConstraint;

@end

@implementation ExampleWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *urlAddress = @"https://github.com/";
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    self.webView.scrollView.scrollEnabled = NO;
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
 
    [nc addObserver:self
           selector:@selector(successfullyRetrievedObjects:)
               name:@"ContentHeightDidChaingedNotification"
             object:nil];
    
    
    VuukleCommentsBuilder *builder = [VuukleCommentsBuilder new];
    
    [[[[[[[[[[[[[[[[[builder firstVuukleTag:@"articleTag1"]
                    setVuukleApiKey:@"777854cd-9454-4e9f-8441-ef0ee894139e"]
                   setVuukleArticleId:@"00048"]
                  setVuukleBaseUrl:@"https://vuukle.com/api.asmx/"]
                 setVuukleEmoteVisible:YES]
                setVuukleHost:@"vuukle.com"]
               setVuukleSecretKey:@"07115720-6848-11e5-9bc9-002590f371ee"]
              setVuukleTimeZone:@"Europe/Kiev"]
             setVuukleTitle:@"Title"]
            setAppName:@"myAppName"]
           setArticleUrl:@"myArticleUrl"]
          setAppID:@"myApId"]
         setVuukleArticleTitle:@"myTitle"]
        setVuukleRefreshVisible:YES]
       addWebViewArticleURL:NO]
      setScrolingVuukleTableView : NO]
     buildVuukle:self.vuukleView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    
    self.webViewHeightConstraint.constant = fittingSize.height;
}

- (void) successfullyRetrievedObjects:(NSNotification*) notification {
    
    self.vuukleHeightConstraint.constant = [notification.object floatValue];
}

@end
