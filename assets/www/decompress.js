/**
 *  
 * @return Object literal singleton instance of DirectoryListing
 */
var Decompress = function() {
};

/**
  * @param directory The directory for which we want the listing
  * @param successCallback The callback which will be called when directory listing is successful
  * @param failureCallback The callback which will be called when directory listing encouters an error
  */
Decompress.prototype.unzip = function(zipfile,directory,successCallback, failureCallback) {

	return PhoneGap.exec(    successCallback,   ls //Success callback from the plugin
      failureCallback,     //Error callback from the plugin
      'DecompressPlugin',  //Tell PhoneGap to run "DirectoryListingPlugin" Plugin
      'unzip',              //Tell plugin, which action we want to perform
      [zipfile,directory]);        //Passing list of args to the plugin


};
 
PhoneGap.addConstructor(function() {
                   PhoneGap.addPlugin("decompress", new Decompress());
                   
               });