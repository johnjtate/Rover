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
 
    NSURL *url = [[self class] roversEndpoint];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error fetching rover names");
            completion(nil, error);
            return;
        }
        
        NSLog(@"%@", response);
        
        if (!data) {
            NSLog(@"No rover name data available");
            completion(nil, nil);
            return;
        }
        
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSDictionary *roverDictionaries = jsonDictionary[@"rovers"];
        NSMutableArray *roverNames = [NSMutableArray array];
        for (NSDictionary *dict in roverDictionaries) {
            NSString *name = dict[@"name"];
            if (name) {
                [roverNames addObject:name];
            }
        }
        completion(roverNames, nil);
    }] resume];
}

- (void)fetchMissionManifestForRoverNamed:(NSString *)roverName completion:(void(^)(JJTRover *rover, NSError *error))completion {
    
    NSURL *url = [[self class] URLForInfoFromRover:roverName];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error fetching rover manifests");
            completion(nil, error);
        }
        
        NSLog(@"%@", response);
        
        if (!data) {
            NSLog(@"No rover manifest data available");
            completion(nil, nil);
        }
        
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSDictionary *manifestDictionary = jsonDictionary[@"photo_manifest"];
        completion([[JJTRover alloc] initWithDictionary:manifestDictionary], nil);
    }] resume];
}

- (void)fetchPhotosFromRover:(JJTRover *)rover onSol:(NSInteger)sol completion:(void(^)(NSArray *photos, NSError *error))completion {
    
    NSURL *url = [[self class] urlForPhotosFromRover:rover.name onSol:sol];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error fetching photos list for rover %@", rover.name);
            completion(nil, error);
        }
        
        NSLog(@"%@", response);
        
        if (!data) {
            NSLog(@"Error with photo list data for rover %@", rover.name);
            completion(nil, nil);
        }
        
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSArray *photoDictionaries = jsonDictionary[@"photos"];
        NSMutableArray *photos = [NSMutableArray array];
        for (NSDictionary *dict in photoDictionaries) {
            JJTPhoto *photo = [[JJTPhoto alloc] initWithDictionary:dict];
            [photos addObject:photo];
        }
        completion(photos, nil);
    }] resume];
}

- (void)fetchImageDataForPhoto:(JJTPhoto *)photo completion:(void(^)(NSData *imageData, NSError *error))completion {
    
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:photo.photoURL resolvingAgainstBaseURL:YES];
    // Image URLs from JSON data use http scheme.  Alternatively, could likely change App Transport Security Settings to allow insecure protocol.  
    urlComponents.scheme = @"https";
    NSURL *imageURL = urlComponents.URL;
    
    [[[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error fetching photo with identifier %@", photo.photoIdentifier);
            completion(nil, error);
        }
        
        if (!data) {
            NSLog(@"Error with photo data for photo with identifier %@", photo.photoIdentifier);
            completion(nil, nil);
        }
        completion(data, nil);
        
    }] resume];
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
