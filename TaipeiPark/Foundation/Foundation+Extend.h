/**
 * \file 	Foundation+Extend.h
 * \brief	The category for the Foundation framework
 *  - 2014/04/02			edmundchen	File created.
 */

#import <Foundation/Foundation.h>

#pragma mark - NSDictionary

@interface NSDictionary (_DefaultValue_)

/**
 * \brief	Get the object with a default value
 * \param	aKey       The key of the dictionary
 *			value      The default value of the result, it will be set if the result is nil.
 * \return	The value of the dictionary with the key
 */
- (id)objectForKey: (id) aKey default: (id) value;

/**
 * \brief	Get the string with a default value
 * \param	aKey       The key of the dictionary
 *			value      The default string of the result, it will be set if the result is nil or @"".
 * \return	The value of the dictionary with the key
 */
- (NSString*)stringForKey: (id) aKey default: (id) value;

@end

#pragma mark - NSMutableArray

@interface NSMutableArray (_Shuffle_)

/**
 * \brief	Shuffle all elements in the mutable array.
 */
- (void)shuffle;

/**
 * \brief	Shuffle the elements in the mutable array with a range.
 * \param   range       The given range to shuffle
 */
- (void)shuffle: (NSRange) range;

@end


#pragma mark - NSArray

@interface NSArray (_Random_)

/**
 * \brief	Get the subarray with random elements.
 * \param   count       The limitation item count to get.
 * \return  The subarray with random elements.
 */
- (NSArray*)random: (NSInteger) count;

/**
 * \brief	Get a random element from the array.
 * \return  The random element.
 */
- (id)random;

@end

#pragma mark - NSString

@interface  NSString (_Encryption_)

+ (NSString*)hexStringFromData: (NSData *) data;

@end

@interface NSString (_URL_)

-(NSString *)urlEncoded;

@end

@interface NSString (_MD5_)

- (NSString*)md5HexDigest;

@end

@interface NSString (_FormatCheck_)

- (BOOL)is_Valid_Email_Format;

@end

@interface NSString (_Convert_)

/**
 *  Convert json format string to json object
 *
 *  @return The converted json object
 */
- (id)To_JsonObject;

@end

#pragma mark - NSData

@interface NSData (_Encryption_)

+ (NSData*)dataFromHexString: (NSString *) string;
- (NSData*)AES256EncryptWithKey: (NSString*) key;
- (NSData*)AES256DecryptWithKey: (NSString*) key;
- (NSString*)newStringInBase64FromData;

@end

#pragma mark - NSCoder

@interface NSCoder (_DefaultValue_)

/**
 *  Decode the object with a default value
 *
 *  @param	key                The key for the NSCoder
 *	@param	defaultValue       The default value of the result, it will be set if the result is nil.
 *  @return     The decoded value for the key
 */
- (id)decodeObjectForKey:(NSString *)key default: (id) defaultValue;

@end

#pragma mark - NSObject

@interface NSObject (_Convert_)

/**
 *  Convert json object to json format string
 *
 *  @return The converted json format string
 */
- (NSString*)to_JsonString;

@end

