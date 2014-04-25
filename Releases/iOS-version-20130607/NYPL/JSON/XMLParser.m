

#import "XMLParser.h"

@implementation XMLParser
@synthesize parsedXML;

- (XMLParser *) initXMLParser :(NSString *)repetingTagStr{
	
	self=[super init];
	parsedXML = [[NSMutableArray alloc] init];
	repetingTag=repetingTagStr;
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"display-name"] || [elementName isEqualToString:@"author"]) {
	}else {
		currentElementValue = nil;
		
	}
	
	if([elementName isEqualToString:repetingTag]) {
		curObj=[[NSMutableDictionary alloc]init];
	}
	for (NSString *key in attributeDict) {
		NSString *vKeyValue = [attributeDict valueForKey:key];
		[curObj setValue:[vKeyValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:key];
	}
	//NSLog(@"Processing Element: %@", elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
	if(!currentElementValue) 
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		
		[currentElementValue appendString:string];
	
	
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	//There is nothing to do if we encounter the tourneys element here.
	//If we encounter the tourneys element howevere, we want to add the book object to the array
	// and release the object.
	if([elementName isEqualToString:repetingTag]) {
		[parsedXML addObject:curObj];
		
		//[curObj release];
		curObj = nil;
	}
	else 
	{
		//		NSString *trimmedString = [currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		//		NSLog(@"Processing Value: %@", currentElementValue);
		[curObj setValue:[currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:elementName];
	}
	if ([elementName isEqualToString:@"display-name"] || [elementName isEqualToString:@"author"]) {
		//	NSLog(@"element name is %@",currentElementValue);
		if ([elementName isEqualToString:@"display-name"])[currentElementValue appendString:@", "];
		
	}
	else {
		//[currentElementValue release];
		currentElementValue = nil;
	}
	
	
}
- (void)parserDidEndDocument:(NSXMLParser *)parser{
	
	
	//	NSLog(@"%@",parsedXML);
}
//- (void) dealloc {
//	
//	[curObj release];
//	[currentElementValue release];
//	[super dealloc];
//}

@end
