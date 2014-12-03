//
//  main.m
//  ROADClassesGenerator
//
//  Copyright (c) 2014 EPAM Systems, Inc. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this
//  list of conditions and the following disclaimer in the documentation and/or
//  other materials provided with the distribution.
//  Neither the name of the EPAM Systems, Inc.  nor the names of its contributors
//  may be used to endorse or promote products derived from this software without
//  specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  See the NOTICE file and the LICENSE file distributed with this work
//  for additional information regarding copyright ownership and licensing
//

#import <Foundation/Foundation.h>
#import "ROADJSONParser.h"
#import "ROADClassModel.h"
#import "ROADClassGenerator.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *jsonPath = [[NSUserDefaults standardUserDefaults] valueForKey:@"source"];
        NSString *outputDirectoryPath = [[NSUserDefaults standardUserDefaults] valueForKey:@"output"];
        NSString *prefix = [[NSUserDefaults standardUserDefaults] valueForKey:@"prefix"];
        if (prefix == nil) {
            prefix = @"";
        }
        if (outputDirectoryPath.length == 0) {
            outputDirectoryPath = [jsonPath stringByDeletingLastPathComponent];
        }
        NSError *error = nil;
        
        [ROADJSONParser parseJSONFromFilePath:jsonPath error:&error];
        if (!error) {
            NSDictionary *models = [ROADClassModel models];
            [models enumerateKeysAndObjectsUsingBlock:^(NSString *key, ROADClassModel *obj, BOOL *stop) {
                NSError *error = nil;
                [ROADClassGenerator generateClassFromClassModel:obj error:&error prefix:prefix outputDirectoryPath:outputDirectoryPath];
                if (!error) {
                    NSLog(@"Class %@ generation complete!", key);
                }
                else {
                    NSLog(@"Error %@ class generation!", key);
                }
            }];
            NSLog(@"Classes generation complete!");
        }
        else {
            NSLog(@"Error json parsing!");
        }
    }
    return 0;
}
