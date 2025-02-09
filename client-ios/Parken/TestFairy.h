#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define TF_DEPRECATED(x)  __attribute__ ((deprecated(x)))

@protocol TestFairySessionStateDelegate <NSObject>
@optional
/**
 * Callback when a session has successfully started on TestFairy.
 */
- (void)sessionStarted;

/**
 * Callback when a session failed to started. Could be because the recording
 * is set to off, session limit has reached, request rejected or other reasons.
 */
- (void)sessionFailed;

/**
 * Callback when session length has reached. For example, if your session
 * is set to maximum of 10 minutes, you will get a callback if such a limit
 * was reached. You can start a new session if you wish to do so.
 */
- (void)sessionLengthReached:(float)secondsFromStartSession;

/**
 * Callback when session recording stopped. Could be because session length
 * reached the limit, stop() was called, app moved to background for too long,
 * or similar reason.
 */
- (void)sessionStopped;

/**
 * Callback when there is an update available. Either this method is called,
 * or noAutoUpdateAvailable() is called.
 */
- (void)autoUpdateAvailable:(NSString *)url;

/**
 * Callback when a user was presented for a request of an auto-update, and
 * then clicked "Yes".
 */
- (void)autoUpdateDownloadStarted;

/**
 * Callback when a user was displayed with a dialog asking if they would like to upgrade,
 * and they clicked "No".
 */
- (void)autoUpdateDismissed;

/**
 * Callback when session start was requested and there was no auto update
 * available. In this case, the user will not be displayed with a dialog box. Note
 * that sessionFailed() could still be called.
 */
- (void)noAutoUpdateAvailable;
@end

@interface TestFairy: NSObject

/**
 * Initialize a TestFairy session.
 *
 * @param appToken Your key as given to you in your TestFairy account
 */
+ (void)begin:(NSString *)appToken;

/**
 * Initialize a TestFairy session with options.
 *
 * @param appToken Your key as given to you in your TestFairy account
 * @param options A dictionary of options controlling the current session
 *        Options include
 * 			- metrics: comma separated string of default metric options such as
 * 				"cpu,memory,network-requests,shake,video,logs"
 * 			- enableCrashReporter: @YES / @NO to enable crash handling. Default is @YES
 */
+ (void)begin:(NSString *)appToken withOptions:(NSDictionary *)options;

/**
 * Initialize the TestFairy SDK with only crash handling. No sessions will be recorded.
 */
+ (void)installCrashHandler:(NSString *)appToken;

/**
 * Change the server endpoint for use with on-premise hosting. Please
 * contact support or sales for more information. Must be called before begin
 *
 * @param serverOverride server address for use with TestFairy
 */
+ (void)setServerEndpoint:(NSString *)serverOverride;

/**
 * Returns SDK version (x.x.x) string
 *
 * @return version
 */
+ (NSString *)version;

/**
 * Hides a specific view from appearing in the video generated.
 * Holds a weak reference to the view
 *
 * @param view The specific view you wish to hide from screenshots
 */
+ (void)hideView:(UIView *)view;

/**
 * Removes a view added to hideView. Useful for table views
 * which reuse cells, where cells only need to be hidden
 * conditionally.
 *
 * @param view The specific view added to hideView
 */
+ (void)unhideView:(UIView *)view;

/**
 * Hides a specific html element from appearing in your WKWebView
 *
 * @param selector The specific selector you wish to hide from screenshots. Multiple selectors can be comma separated
 */
+ (void)hideWebViewElements:(NSString *)selector;

/**
 * Pushes the feedback view controller. Hook a button
 * to this method to allow users to provide feedback about the current
 * session. All feedback will appear in your build report page, and in
 * the recorded session page.
 */
+ (void)pushFeedbackController TF_DEPRECATED("Please refer to showFeedbackForm");

/**
 * Programmatically display the feedback form to users.
 * Users can provide feedback about the current session.
 * All feedback will appear in your build report page,
 * and in the recorded session page.
 */
+ (void)showFeedbackForm;

/**
 * Displays the feedback form. Allow users to provide
 * feedback without prior call to begin. All feedback
 * will appear in your build report page, and in
 * "Feedbacks" tab.
 *
 * This method is different from showFeedbackForm by
 * that it does not require a call to begin().
 *
 * @param appToken Your key as given to you in your TestFairy account
 * @param takeScreenshot whether screenshot should be automatically added
 */
+ (void)showFeedbackForm:(NSString *)appToken takeScreenshot:(BOOL)takeScreenshot;


/**
 * Start collecting feedback by having your users either capture a
 * screenshot or recording before filling the Feedback form. All
 * feedbacks will appear in your build report page, and on the
 * "Feedbacks" tab.
 *
 * Does not require a call to begin().
 *
 * @param appToken Your key as given to you in your TestFairy account
 * @param intent Either "video" or "screenshot"
 */
+ (void)startFeedback:(NSString *)appToken withIntent:(NSString *)intent;

/**
 * Send a feedback on behalf of the user. Call when using a in-house
 * feedback view controller with a custom design and feel. Feedback will
 * be associated with the current session.
 *
 * @param feedback Feedback text
 */
+ (void)sendUserFeedback:(NSString *)feedback;

/**
 * Send a feedback on behalf of the user. Call when using a in-house
 * feedback view controller with a custom design and feel. Feedback will
 * be associated with the current session.
 *
 * @param text Feedback text
 */
+ (void)sendUserFeedback:(NSString *)appToken text:(NSString *)text screenshot:(UIImage *)image;

/**
 * Proxy didUpdateLocation delegate values and these
 * locations will appear in the recorded sessions. Useful for debugging
 * actual long/lat values against what the user sees on screen.
 *
 * @param locations Array of CLLocation. The first object of the array will determine the user location
 */
+ (void)updateLocation:(NSArray *)locations;

/**
 * Marks a checkpoint in session. Use this text to tag a session
 * with a checkpoint name. Later you can filter sessions where your
 * user passed through this checkpoint.
 *
 * @param name The checkpoint name
 */
+ (void)checkpoint:(NSString *)name TF_DEPRECATED("Please refer to addEvent:");

/**
 * Marks an event in session timeline. Use this text to tag a session
 * with an event name. Later you can filter sessions where your
 * user passed through this event.
 *
 * @param name The event name
 */
+ (void)addEvent:(NSString *)name;

/**
 * Sets a correlation identifier for this session. This value can
 * be looked up via web dashboard. For example, setting correlation
 * to the value of the user-id after they logged in. Can be called
 * only once per session (subsequent calls will be ignored.)
 *
 * @param correlationId Id for the current session
 */
+ (void)setCorrelationId:(NSString *)correlationId TF_DEPRECATED("Please refer to setUser:");

/**
 * Sets a correlation identifier for this session. This value can
 * be looked up via web dashboard. For example, setting correlation
 * to the value of the user-id after they logged in. Can be called
 * only once per session (subsequent calls will be ignored.)
 *
 * @param correlationId Id for the current session
 */
+ (void)identify:(NSString *)correlationId TF_DEPRECATED("Please refer to setAttribute: and setUser:");

/**
 * Sets a correlation identifier for this session. This value can
 * be looked up via web dashboard. For example, setting correlation
 * to the value of the user-id after they logged in. Can be called
 * only once per session (subsequent calls will be ignored.)
 *
 * @param correlationId Id for the current session
 * @param traits Attributes and custom attributes to be associated with this session
 */
+ (void)identify:(NSString *)correlationId traits:(NSDictionary *)traits TF_DEPRECATED("Please refer to setAttribute:");

/**
 * Pauses the current session. This method stops recoding of
 * the current session until resume has been called.
 *
 * @see resume
 */
+ (void)pause;

/**
 * Resumes the recording of the current session. This method
 * resumes a session after it was paused.
 *
 * @see pause
 */
+ (void)resume;

/**
 * Returns the address of the recorded session on testfairy's
 * developer portal. Will return nil if recording not yet started.
 *
 * @return session URL
 */
+ (NSString *)sessionUrl;

/**
 * Takes a screenshot.
 *
 */
+ (void)takeScreenshot;

/**
 * Adds a screenshot to the current moment in session.
 * Overrides the current screen recording system
 *
 * @param image Screenshot to add
 */
+ (void)addScreenshot:(UIImage *)image;

/**
 * Set the name of the current screen. Useful for single page
 * applications which use a single UIViewController.
 *
 * @param name logic name of current screen
 */
+ (void)setScreenName:(NSString *)name;

/**
 * Stops the current session recording. Unlike 'pause', when
 * calling 'resume', a new session will be created and will be
 * linked to the previous recording. Useful if you want short
 * session recordings of specific use-cases of the app. Hidden 
 * views and user identity will be applied to the new session 
 * as well, if started. 
 */
+ (void)stop;

/**
 * Records a session level attribute which can be looked up via web dashboard.
 *
 * @param key The name of the attribute. Cannot be nil.
 * @param value The value associated with the attribute. Cannot be nil.
 * @return YES if successfully set attribute value, NO if failed with error in log.
 *
 * @note The SDK limits you to storing 64 named attributes. Adding more than 64 will fail and return NO.
 */
+ (BOOL)setAttribute:(NSString *)key withValue:(NSString *)value;

/**
 * Records a user identified as an attribute. We recommend passing values such as
 * email, phone number, or user id that your app may use.
 *
 * @param userId The identifying user. Cannot be nil.
 *
 */
+ (void)setUserId:(NSString *)userId;

/**
 * Remote logging. These logs will be sent to the server,
 * but will not appear in the console.
 */

+ (void)log:(NSString *)message;

/**
 * Attach a file to the session. A maximum of 5 files may be attached. Each file cannot be more
 * than 15 mb in size. In order to see if the file successfully uploads or fails, please view
 * the logs.
 *
 * @param file path to file on disk.
 *
 */
+ (void)attachFile:(NSURL *)file;

/**
 * Query to see if the previous session crashed. Can be called before or
 * after calling begin.
 */
+ (BOOL)didLastSessionCrash;

/**
 * Enables the ability to capture crashes. TestFairy
 * crash handler is installed by default. Once installed
 * it cannot be uninstalled. Must be called before begin.
 */
+ (void)enableCrashHandler;

/**
 * Disables the ability to capture crashes. TestFairy
 * crash handler is installed by default. Once installed
 * it cannot be uninstalled. Must be called before begin.
 */
+ (void)disableCrashHandler;

/**
 * Enables recording of a metric regardless of build settings.
 * Valid values include "cpu", "memory", "logcat", "battery", "network-requests"
 * A metric cannot be enabled and disabled at the same time, therefore
 * if a metric is also disabled, the last call to enable to disable wins.
 * Must be called be before begin.
 */
+ (void)enableMetric:(NSString *)metric;

/**
 * Disables recording of a metric regardless of build settings.
 * Valid values include "cpu", "memory", "logcat", "battery", "network-requests"
 * A metric cannot be enabled and disabled at the same time, therefore
 * if a metric is also disabled, the last call to enable to disable wins.
 * Must be called be before begin.
 */
+ (void)disableMetric:(NSString *)metric;

/**
 * Enables the ability to capture video recording regardless of build settings.
 * Valid values for policy include "always" and "wifi"
 * Valid values for quality include "high", "low", "medium"
 * Values for fps must be between 0.1 and 2.0. Value will be rounded to
 * the nearest frame.
 */
+ (void)enableVideo:(NSString *)policy quality:(NSString *)quality framesPerSecond:(float)fps;

/**
 * Disables the ability to capture video recording. Must be
 * called before begin.
 */
+ (void)disableVideo;

/**
 * Enables the ability to present the feedback form
 * based on the method given. Valid values include
 * "shake", "screenshot" or "shake|screenshot". If an
 * unrecognized method is passed, the value defined in
 * the build settings will be used. Must be called before
 * begin.
 */
+ (void)enableFeedbackForm:(NSString *) method;

/**
 * Disables the ability to present users with feedback when
 * devices is shaken, or if a screenshot is taken. Must be called
 * before begin.
 */
+ (void)disableFeedbackForm;

/**
 * Disable auto updates for this build. Even if there's a newer
 * build available through TestFairy, ignore it, and continue
 * using the current build. Must be called before begin
 */
+ (void)disableAutoUpdate;

/**
 * Sets the maximum recording time. Minimum value is 60 seconds,
 * else the value defined in the build settings will be used. The
 * maximum value is the lowest value between this value and the
 * value defined in the build settings.
 * Time is rounded to the nearest minute.
 * Must be called before begin.
 */
+ (void)setMaxSessionLength:(float)seconds;

/**
 * Determines whether the "email field" in the Feedback form will be visible or not.
 * default is true
 *
 * @param visible BOOL
 */
+ (void)setFeedbackEmailVisible:(BOOL)visible;

/**
 * Customize the feedback form
 *
 * Accepted dictionary values: @{
 * 	@"defaultText": <Default feedback text>,
 * 	@"isEmailMandatory": @NO|@YES,
 * 	@"isEmailVisible": @NO|@YES
 * }
 *
 * defaultText: By setting a default text, you will override the initial content of the text area
 * inside the feedback form. This way, you can standardize the way you receive feedbacks
 * by specifying guidelines to your users.
 *
 * isEmailMandatory: Determines whether the user has to add his email address to the feedback. Default is true
 *
 * isEmailVisible: Determines whether the email field is displayed in the feedback form. Default is true
 */
+ (void)setFeedbackOptions:(NSDictionary *)options;

/**
 * Query the distribution status of this build. Distribution is not required
 * for working with the TestFairy SDK, meaning, you can use the SDK with the App Store.
 *
 * The distribution status can be either "enabled" or "disabled", and optionally, can have
 * an auto-update. This method is useful if you're using TestFairy in your development
 * stage and want to know if you expired the distribution of this version in your dashboard.
 *
 * Possible response keys:
 *
 * response[@"status"] = @"enabled" or @"disabled"
 * response[@"autoUpdateDownloadUrl"] = @"<url to download url>"
 *
 * @param appToken App token as used with begin()
 * @param callback to receive asynchornous response. Response dictionary can be nil
 */
+ (void)getDistributionStatus:(NSString *)appToken callback:(void(^)(NSDictionary<NSString *, NSString *> *, NSError*))callback;

/**
 * Enable end-to-end encryption for this session. Screenshots and logs will be encrypted using
 * this RSA key. Please refer to the documentation to learn more about the subject and how
 * to create public/private key pair.
 *
 * @param publicKey RSA Public Key converted to DER format and encoded in base64
 */
+ (void)setPublicKey:(NSString *)publicKey;

/**
 * Define whether logs or screenshots are encrypted. Should be called before setPublicKey
 */
+ (void)setEncryptionPolicy:(BOOL)encryptScreenshots encryptLogs:(BOOL)encryptLogs;

/**
 * Set the delegate object to listent to TestFairy events. See @TestFairySessionStateDelegate
 * for more information
 */
+ (void)setSessionStateDelegate:(id<TestFairySessionStateDelegate>)delegate;

/**
 * Call this function to log your network events.
 */
+ (void)addNetwork:(NSURLSessionTask *)task error:(NSError *)error;
+ (void)addNetwork:(NSURL *)url
			method:(NSString *)method
			code:(int)code
 startTimeInMillis:(long)startTime
   endTimeInMillis:(long)endTime
	   requestSize:(long)requestSize
	  responseSize:(long)responseSize
	  errorMessage:(NSString*)error;
/**
 * Send an NSError to TestFairy.
 * Note, this function is limited to 5 errors.
 * @param error NSError
 * @param trace Stacktrace
 */
+ (void)logError:(NSError *)error stacktrace:(NSArray *)trace;
+ (void)logError:(NSError *)error;

/**
 * Force crash (only for testing purposes)
 */
+ (void)crash;

@end

#if __cplusplus
extern "C" {
#endif
	
/**
 * Remote logging, use TFLog as you would use printf. These logs will be sent to the server,
 * but will not appear in the console.
 *
 * @param format sprintf-like format for the arguments that follow
 */
void TFLog(NSString *format, ...) __attribute__((format(__NSString__, 1, 2)));

/**
 * Remote logging, use TFLogv as you would use printfv. These logs will be sent to the server,
 * but will not appear in the console.
 *
 * @param format sprintf-like format for the arguments that follow
 * @param arg_list list of arguments
 */
void TFLogv(NSString *format, va_list arg_list);
	
#if __cplusplus
}
#endif

extern NSString *const TFSDKIdentityTraitNameKey;
extern NSString *const TFSDKIdentityTraitEmailAddressKey;
extern NSString *const TFSDKIdentityTraitBirthdayKey;
extern NSString *const TFSDKIdentityTraitGenderKey;
extern NSString *const TFSDKIdentityTraitPhoneNumberKey;
extern NSString *const TFSDKIdentityTraitWebsiteAddressKey;
extern NSString *const TFSDKIdentityTraitAgeKey;
extern NSString *const TFSDKIdentityTraitSignupDateKey;
extern NSString *const TFSDKEnableCrashReporterKey;
extern NSString *const TestFairyDidShakeDevice;
extern NSString *const TestFairyWillProvideFeedback;
extern NSString *const TestFairyDidCancelFeedback;
extern NSString *const TestFairyDidSendFeedback;
