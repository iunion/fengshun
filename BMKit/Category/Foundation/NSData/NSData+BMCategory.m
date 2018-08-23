//
//  NSData+BMCategory.m
//  BMBasekit
//
//  Created by DennisDeng on 12-6-11.
//  Copyright (c) 2012年 DennisDeng. All rights reserved.
//

#import "NSData+BMCategory.h"
#import "NSString+BMCategory.h"


#pragma mark -
#pragma mark Category

@implementation NSData (BMCategory)

+ (NSData *)bm_dataFromHexString:(NSString *)hexString
{
    NSString *trimHexString = [hexString bm_trimAllSpace];
    NSUInteger len = [trimHexString length] / 2;    // Target length
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};
    
    for (int i = 0; i < [trimHexString length] / 2; i++)
    {
        byte_chars[0] = [trimHexString characterAtIndex:i*2];
        byte_chars[1] = [trimHexString characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    
    NSData *data = [NSData dataWithBytes:buf length:len];
    free(buf);
    return data;
}

// data转换为十六进制的string
- (NSString *)bm_hexStringValue
{
    NSMutableString *stringBuffer = [NSMutableString stringWithCapacity:(self.length * 2)];
    
    const unsigned char *dataBuffer = [self bytes];
    
    NSUInteger i;
    for (i = 0; i < self.length; ++i)
    {
        [stringBuffer appendFormat:@"%02x", dataBuffer[i]];
    }
    
    return [stringBuffer copy];
}

- (void)bm_logWithType:(NSDataBmLogType)type
{
    NSInteger length = [self length];
    unsigned char aBuffer[length];
    
    [self getBytes:aBuffer length:length];
    
    NSString *formatStr = @"";
    for (int i=0; i<length; i++)
    {
        int num = aBuffer[i];
        switch (type)
        {
            case NSDataBmLogType_Num:
                formatStr = [formatStr stringByAppendingString:[NSString stringWithFormat:@"%d ", num]];
                break;
                
            case NSDataBmLogType_UpperCaseHex:
                formatStr = [formatStr stringByAppendingString:[NSString stringWithFormat:@"%02X ", num]];
                break;
                
            case NSDataBmLogType_LowerCaseHex:
            default:
                formatStr = [formatStr stringByAppendingString:[NSString stringWithFormat:@"%02x ", num]];
                break;
        }
    }
    
    BMLog(@"%@", formatStr);
}

@end


#pragma mark -
#pragma mark RSHexDump

const NSUInteger kDefaultMaxBytesToHexDump = 1024;

@implementation NSData (BMRSHexDump)

//- (NSString *)description
//{
//	return [self descriptionFromOffset:0];
//}

- (NSString *)bm_descriptionFromOffset:(NSInteger)startOffset
{
	return [self bm_descriptionFromOffset:startOffset limitingToByteCount:kDefaultMaxBytesToHexDump];
}

- (NSString *)bm_descriptionFromOffset:(NSInteger)startOffset limitingToByteCount:(NSUInteger)maxBytes
{
    unsigned char *bytes = (unsigned char *)[self bytes];
    NSUInteger stopOffset = [self length];
    
	// Translate negative offset to positive, by subtracting from end
	if (startOffset < 0)
	{
		startOffset = [self length] + startOffset;
	}
    
	// Do we have more data than the caller wants?
	//BOOL curtailOutput = NO;
	if ((stopOffset - startOffset) > maxBytes)
	{
		//curtailOutput = YES;
		stopOffset = startOffset + maxBytes;
	}
    
	// If we're showing a subset, we'll tack in info about that
	NSString* curtailInfo = @"";
	if ((startOffset > 0) || (stopOffset < [self length]))
	{
		curtailInfo = [NSString stringWithFormat:@" (showing bytes %ld through %ld)", (long)startOffset, (long)stopOffset];
	}
	
	// Start the hexdump out with an overview of the content
	NSMutableString *buf = [NSMutableString stringWithFormat:@"NSData %ld bytes%@:\n", (long)[self length], curtailInfo];
	
	// One row of 16-bytes at a time ...
    NSInteger i, j;
    for ( i = startOffset ; i < stopOffset ; i += 16 )
    {
		// Show the row in Hex first
        for ( j = 0 ; j < 16 ; j++ )
        {
            NSInteger rowOffset = i+j;
            if (rowOffset < stopOffset)
            {
                [buf appendFormat:@"%02X ", bytes[rowOffset]];
            }
            else
            {
                [buf appendFormat:@"   "];
            }
        }
		
		// Now show in ASCII
        [buf appendString:@"| "];
        for ( j = 0 ; j < 16 ; j++ )
        {
            NSInteger rowOffset = i+j;
            if (rowOffset < stopOffset)
            {
                unsigned char theChar = bytes[rowOffset];
                if (theChar < 32 || theChar > 127)
                {
                    theChar ='.';
                }
                [buf appendFormat:@"%c", theChar];
            }
        }
		
		// If we're not on the last row, tack on a newline
		if (i+16 < stopOffset)
		{
			[buf appendString:@"\n"];
		}
	}
	
    return buf;
}

@end
