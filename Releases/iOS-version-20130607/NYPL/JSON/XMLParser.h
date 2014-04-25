

#import <UIKit/UIKit.h>

@interface XMLParser : NSObject<NSXMLParserDelegate> {
	
	NSMutableString *currentElementValue;
	NSString *repetingTag;
	NSMutableArray *parsedXML;
	NSMutableDictionary *curObj;
}
@property (nonatomic, retain) NSMutableArray *parsedXML;

- (XMLParser *) initXMLParser :(NSString *)repetingTagStr ;

@end
