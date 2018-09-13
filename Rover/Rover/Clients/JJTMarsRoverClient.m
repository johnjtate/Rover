//
//  JJTMarsRoverClient.m
//  Rover
//
//  Created by John Tate on 9/12/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

#import "JJTMarsRoverClient.h"
#import "JJTRover.h"
#import "JJTPhoto.h"

@implementation JJTMarsRoverClient

- (void)fetchAllMarsRoversWithCompletion:(void(^)(NSArray *roverNames, NSError *error))completion {
 
    
}

- (void)fetchMissionManifestForRoverNamed:(NSString *)name completion:(void(^)(JJTRover *rover, NSError *error))completion {
    
    
}

- (void)fetchPhotosFromRover:(JJTRover *)rover onSol:(NSInteger)sol completion:(void(^)(NSArray *photos, NSError *error))completion {
    
    
}

- (void)fetchImageDataForPhoto:(JJTPhoto *)photo completion:(void(^)(NSData *imageData, NSError *error))completion {
    
    
}

#pragma mark - Private

+ (NSString *)apiKey {
    static NSString *apiKey = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *apiKeysURL = [[NSBundle mainBundle] URLForResource:@"APIKeys" withExtension:@"plist"];
        if (!apiKeysURL) {
            NSLog(@"Error! APIKeys file not found!");
            return;
        }
        NSDictionary *apiKeys = [[NSDictionary alloc] initWithContentsOfURL:apiKeysURL];
        apiKey = apiKeys[@"APIKey"];
    });
    return apiKey;
}

#pragma mark - URLs

// Create a class method called baseURL that returns an instance of NSURL created from the base url of the API
+ (NSURL *)baseURL {
    return [NSURL URLWithString:@"https://api.nasa.gov/mars-photos/api/v1"];
}

// URL for rover endpoint
// URL example: https://api.nasa.gov/mars-photos/api/v1/rovers?api_key=3h1jtAaOPPmCyPQExwef4nUEI42fb06ISNhuMPoy
+ (NSURL *)roversEndpoint {
    NSURL *roversURL = [[self baseURL] URLByAppendingPathComponent:@"rovers"];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:roversURL resolvingAgainstBaseURL:YES];
    urlComponents.queryItems = @[[NSURLQueryItem queryItemWithName:@"api_key" value:@"3h1jtAaOPPmCyPQExwef4nUEI42fb06ISNhuMPoy"]];
    return urlComponents.URL;
}


// Create a class method called URLForInfoForRover that takes in a string called 'roverName' and returns an NSURL pointing to the mission manifest of the rover passed in
// URL example: https://api.nasa.gov/mars-photos/api/v1/manifests/Curiosity/?api_key=3h1jtAaOPPmCyPQExwef4nUEI42fb06ISNhuMPoy
+ (NSURL *)URLForInfoFromRover:(NSString *)roverName {
    NSURL *url = [self baseURL];
    url = [url URLByAppendingPathComponent:@"rovers"];
    url = [url URLByAppendingPathComponent:roverName];
    
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    urlComponents.queryItems = @[[NSURLQueryItem queryItemWithName:@"api_key" value:@"3h1jtAaOPPmCyPQExwef4nUEI42fb06ISNhuMPoy"]];
    return urlComponents.URL;
}

// Create a class method called urlForPhotosFromRover that takes in a string called 'roverName' and the sol that you want photos for, then like above, return a new, more specific NSURL pointing to the photos for the given rover and sol
// URL example: https://api.nasa.gov/mars-photos/api/v1/rovers/Curiosity/photos?sol=1&api_key=3h1jtAaOPPmCyPQExwef4nUEI42fb06ISNhuMPoy
+ (NSURL *)urlForPhotosFromRover:(NSString *)roverName onSol:(NSInteger)sol {
    NSURL *url = [self baseURL];
    url = [url URLByAppendingPathComponent:@"rovers"];
    url = [url URLByAppendingPathComponent:roverName];
    url = [url URLByAppendingPathComponent:@"photos"];

    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    urlComponents.queryItems = @[[NSURLQueryItem queryItemWithName:@"sol" value:[@(sol) stringValue]], [NSURLQueryItem queryItemWithName:@"api_key" value:@"3h1jtAaOPPmCyPQExwef4nUEI42fb06ISNhuMPoy"]];
    return urlComponents.URL;
}

@end
