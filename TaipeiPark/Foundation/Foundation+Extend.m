/* Copyright (c) 2014  ASUSTOR Inc.  All Rights Reserved. */
/**
 * \file 	Foundation+Extend.m
 * \brief	The category for the Foundation framework
 *  - 2014/04/02			edmundchen	File created.
 */

#import "Foundation+Extend.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

#pragma mark - NSDictionary

@implementation NSDictionary (_DefaultValue_)

- (id)objectForKey: (id) aKey default: (id) value
{
    id ret = [self objectForKey:aKey];
    
    if (nil == ret)
        return value;
    
    return ret;
}

- (NSString*)stringForKey: (id) aKey default: (id) value
{
    id ret = [self objectForKey:aKey];
    
    if (nil != ret)
    {
        if ([ret isKindOfClass:[NSString class]] && 0 < [ret length])
            return ret;
        else if ([ret isKindOfClass:[NSNumber class]])
            return [ret stringValue];
    }
    
    return value;
}

@end

#pragma mark - NSMutableArray

@implementation NSMutableArray (_Shuffle_)

- (void)shuffle
{
    [self shuffle:NSMakeRange(0, self.count)];
}

- (void)shuffle: (NSRange) range
{
    NSAssert((range.location + range.length <= self.count), @"Out of range for the array");
    
    NSUInteger count = range.location + range.length;
    
    for (NSUInteger i = range.location; i < count; i++)
    {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end

#pragma mark - NSArray

@implementation NSArray (_Random_)

- (NSArray*)random: (NSInteger) count
{
    NSInteger nCount = MIN(count, self.count);
    
    if (0 < nCount)
    {
        NSMutableArray *aryTemp = [NSMutableArray arrayWithArray:self];
        
        for (NSUInteger i = 0; i < nCount; i++)
        {
            // Select a random element between i and end of array to swap with.
            NSInteger nElements = nCount - i;
            NSInteger n = (arc4random() % nElements) + i;
            [aryTemp exchangeObjectAtIndex:i withObjectAtIndex:n];
        }
        
        return [aryTemp subarrayWithRange:NSMakeRange(0, nCount)];
    }
    
    return nil;
}

- (id)random
{
    if (0 < self.count)
    {
        NSInteger idx = arc4random() % self.count;
        
        return [self objectAtIndex:idx];
    }
    
    return nil;
}

@end

#pragma mark - NSString

@implementation NSString (_Encryption_)

// For converting Encrypted Data into NSString after the encryption
+ (NSString*)hexStringFromData:(NSData *)data
{
    unichar* hexChars = (unichar*)malloc(sizeof(unichar) * (data.length*2));
    unsigned char* bytes = (unsigned char*)data.bytes;
    for (NSUInteger i = 0; i < data.length; i++) {
        unichar c = bytes[i] / 16;
        if (c < 10) c += '0';
        else c += 'a' - 10;
        hexChars[i*2] = c;
        c = bytes[i] % 16;
        if (c < 10) c += '0';
        else c += 'a' - 10;
        hexChars[i*2+1] = c;
    }
    NSString* retVal = [[NSString alloc] initWithCharactersNoCopy:hexChars
                                                           length:data.length*2
                                                     freeWhenDone:YES];
    return retVal;
}

@end

@implementation NSString (_URL_)

-(NSString *) urlEncoded
{
    NSString *strURL = nil;
    CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(
                                                                    NULL,
                                                                    (__bridge CFStringRef)self,
                                                                    NULL,
                                                                    (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                    kCFStringEncodingUTF8 );

    strURL = [NSString stringWithFormat:@"%@", urlString];
    CFRelease(urlString);
    return strURL;
}

@end

@implementation NSString (_MD5_)

- (NSString*)md5HexDigest
{
    const char* str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    
    return ret;
}

@end

@implementation NSString (_FormatCheck_)

- (BOOL)is_Valid_Email_Format
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

@end

@implementation NSString (_Convert_)

- (id)To_JsonObject
{
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    if (jsonData)
        return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    
    return nil;
}

@end

#pragma mark - NSData

static char base64[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSData (_Encryption_)

- (NSData*)AES256EncryptWithKey:(NSString*)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

- (NSData *)AES256DecryptWithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

- (NSString *)newStringInBase64FromData
{
    NSMutableString *dest = [[NSMutableString alloc] initWithString:@""];
    unsigned char * working = (unsigned char *)[self bytes];
    NSUInteger srcLen = [self length];
    
    for (int i=0; i<srcLen; i += 3) {
        for (int nib=0; nib<4; nib++) {
            int byt = (nib == 0)?0:nib-1;
            int ix = (nib+1)*2;
            
            if (i+byt >= srcLen) break;
            
            unsigned char curr = ((working[i+byt] << (8-ix)) & 0x3F);
            
            if (i+nib < srcLen) curr |= ((working[i+nib] >> ix) & 0x3F);
            
            [dest appendFormat:@"%c", base64[curr]];
        }
    }
    
    return dest;
}

// For Converting incoming HexString into NSData
+ (NSData *)dataFromHexString:(NSString *)string
{
    NSMutableData *stringData = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [string length] / 2; i++) {
        byte_chars[0] = [string characterAtIndex:i*2];
        byte_chars[1] = [string characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1];
    }
    
    return stringData;
}

@end


#pragma mark - NSCoder

@implementation NSCoder (_DefaultValue_)

- (id)decodeObjectForKey:(NSString *)key default: (id) defaultValue
{
    id obj = [self decodeObjectForKey:key];
    
    if (nil == obj)
        obj = defaultValue;
    
    return obj;
}

@end


#pragma mark - NSObject

@implementation NSObject (_Convert_)

- (NSString*)to_JsonString
{
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
        
        if (jsonData)
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return nil;
}

@end
