//
//  NKOBonjourAPI.m
//  Dashboard Server
//
//  Created by Carlos Vidal Pallín on 26/02/2014.
//  Copyright (c) 2014 nakioStudio. All rights reserved.
//

#import "NKOBonjourAPI.h"
#import "QServer.h"

NSString *const NKOTcpPrefix = @"_fwt._tcp.";

@interface NKOBonjourAPI() <QServerDelegate, NSStreamDelegate>

@property (nonatomic, strong) NKOBonjourAPIMessageReceivedBlock messageReceivedBlock;

@property (nonatomic, strong) QServer *server;
@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, assign) NSUInteger streamOpenCount;
    
@end

@implementation NKOBonjourAPI{
    NSMutableData *_data;
    NSUInteger bytesRead;
}

+ (NKOBonjourAPI *)sharedInstance
{
    static dispatch_once_t once;
    static NKOBonjourAPI * sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}
    
- (id)init
{
    self = [super init];
    
    if (self != nil){
        
    }
    
    return self;
}
    
#pragma mark - Private methods
- (void)startServerWithMessageReceivedBlock:(NKOBonjourAPIMessageReceivedBlock)messageReceivedBlock
{
    self.messageReceivedBlock = messageReceivedBlock;
    
    if (self.server != nil){
        return;
    }
    
    self.server = [[QServer alloc] initWithDomain:@"local." type:NKOTcpPrefix name:nil preferredPort:0];
    [self.server setDelegate:self];
    [self.server start];
    
    if (self.server.isDeregistered) {
        [self.server reregister];
    }
}

#pragma mark - Connection management
- (void)connectToService:(NSNetService*)service
{
    NSInputStream *serviceInputStream;
    NSOutputStream *serviceOutputStream;
    
    BOOL connected = [service getInputStream:&serviceInputStream outputStream:&serviceOutputStream];
    
    if (connected == YES){
        self.inputStream = serviceInputStream;
        self.outputStream = serviceOutputStream;
        
        [self openStreams];
    }
    else{
        [self closeStreams];
        
        if (self.server.isDeregistered){
            [self.server reregister];
        }
    }
}

- (void)disconnect
{
    [self closeStreams];
    
    if (self.server.isDeregistered){
        [self.server reregister];
    }
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode
{
    switch(eventCode)
    {
        case NSStreamEventOpenCompleted:{
            self.streamOpenCount += 1;
            
            if (self.streamOpenCount == 2){
                [self.server deregister];
            }
            break;
        }
        case NSStreamEventHasSpaceAvailable:{

            break;
        }
        case NSStreamEventHasBytesAvailable:{
            if(!_data) {
                _data = [NSMutableData data];
            }
            uint8_t buf[1024];
            NSInteger len = 0;
            len = [self.inputStream read:buf maxLength:1024];
            if(len) {
                [_data appendBytes:(const void *)buf length:len];
                // bytesRead is an instance variable of type NSNumber.
                bytesRead = bytesRead + len;
                
                for (int i = 0; i < len; i++){
                    if (buf[i] == '\0'){
                        NSString *message = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
                        _data = nil;
                        self.messageReceivedBlock(message);
                    }
                }
            } else {
                NSLog(@"no buffer!");
            }
            break;
        }
        default:
        case NSStreamEventErrorOccurred:
        case NSStreamEventEndEncountered:{
            [self closeStreams];
            
            // If our server is deregistered, reregister it.
            if (self.server.isDeregistered){
                [self.server reregister];
            }
            break;
        };
    }
}
    
- (void)openStreams
{
    [self.inputStream  setDelegate:self];
    [self.inputStream  scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.inputStream  open];
    
    [self.outputStream setDelegate:self];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream open];
}
    
- (void)closeStreams
{
    if (self.inputStream != nil){
        [self.server closeOneConnection:self];
        
        [self.inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.inputStream close];
        self.inputStream = nil;
        
        [self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.outputStream close];
        self.outputStream = nil;
    }
    self.streamOpenCount = 0;
}

- (void)sendMessage:(NSString*)message
{
    const char *messageChars = [message UTF8String];
    
    for (int i = 0; i < message.length; i++){
        [self send:messageChars[i]];
    }
    
    [self send:'\0'];
}

- (void)send:(uint8_t)message
{
    // Only write to the stream if it has space available, otherwise we might block.
    // TODO: handle this properly
    
    if ( [self.outputStream hasSpaceAvailable]){
        NSInteger   bytesWritten;
        
        bytesWritten = [self.outputStream write:&message maxLength:sizeof(message)];
        if (bytesWritten != sizeof(message)){
            [self closeStreams];
            
            // If our server is deregistered, reregister it.
            if (self.server.isDeregistered){
                [self.server reregister];
            }
        }
    }
}
    
#pragma mark - QServer delegate
- (void)serverDidStart:(QServer *)server
{
    
}
    
- (id)server:(QServer *)server connectionForInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream
{
    id  result;
    
    if (self.inputStream != nil){
        // We already have a connection in place; reject this new one.
        result = nil;
    }
    else{
        // Start up the new connection.  Start by deregistering the server.
        [self.server deregister];
        
        // Latch the input and output sterams and kick off an open.
        self.inputStream  = inputStream;
        self.outputStream = outputStream;
        
        [self openStreams];
        
        result = self;
    }
    
    return result;
}
    
- (void)server:(QServer *)server didStopWithError:(NSError *)error
{
    // This is called when the server stops of its own accord.  The only reason
    // that might happen is if the Bonjour registration fails when we reregister
    // the server, and that's hard to trigger because we use auto-rename.  I've
    // left an assert here so that, if this does happen, we can figure out why it 
    // happens and then decide how best to handle it.

}
    
- (void)server:(QServer *)server closeConnection:(id)connection
{
    //Called when the server shuts down

}
    
@end
