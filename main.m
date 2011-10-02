//
//  main.m
//  MComm
//
//  Created by Marc Schweikert on 1/29/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * Below is some experimental code that is platform specific.
 *
 * Valgrind is a memory management tool that helps find memory leaks.
 * In order to use valgrind, you must install it and set the path below.
 * Then, uncomment the #define so that the code in main is executed
 */

//#define VALGRIND "/usr/local/bin/valgrind"

int main(int argc, char *argv[]) {
	#ifdef VALGRIND
    
	// Using the valgrind build config, rexec ourself in valgrind
    if (argc < 2 || (argc >= 2 && strcmp(argv[1], "-valgrind") != 0)) {
        execl(VALGRIND, VALGRIND, "--leak-check=full --show-reachable=yes", argv[0], "-valgrind",
              NULL);
    }
	
	#endif
	
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
