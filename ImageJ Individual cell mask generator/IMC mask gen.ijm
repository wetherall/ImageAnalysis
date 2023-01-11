//   Hello. The purpose of this macro is to take a multi channel tiff file of converted IMC data,
//   and create a multichannel binary image where each channel contains one egg. 
//   This is used for analysis of the original image in python,
//   where by masking the original multichannel image with a given channel from this output will isolate single eggs.


//For some reason ImageJ no longer remembers this, but threshholding and deleting things gets a bit wonky without it
setOption("BlackBackground", true);

//  This section gets the filename and asks which channel you want to use as the mask
maskingchannel = getString("Which channel do you want to use to create masks?", "Type a number here")
Stack.getDimensions(width, height, channels, slices, frames) //creates variables with dimensional info
title = getInfo("image.filename");
run("Split Channels");
selectWindow("C"+maskingchannel+"-"+title);
original = getImageID()


//This section allows the user to customise where the mask boundaries are
run("Enhance Contrast", "saturated=0.5");
run("Smooth");
run("Smooth");
run("Threshold...");
setAutoThreshold("Default dark");
waitForUser("Waiting for user to set threshold. You must click apply. Press Okay once done.");


//This section trims off extra blebs and generates an ROI for each egg
run("Watershed");
waitForUser("Press Okay if masks look acceptable. You can use eraser tool if necessary first.");
run("Analyze Particles...", "size=250-Infinity show=Masks clear add in_situ");


//This section counts the number off eggs in the image then clears the ROI manager

roicount = roiManager("count");
roiManager("delete")

//This for loop iterates through the eggs, 
//creating an image for each egg on its own
for (i = 0; i < roicount; i++) { // outer 'for' loop iterating through eggs

	run("Duplicate...", "title="+i); //creates a new image with all eggs
	selectWindow(""+i); //ensures new image selected
	
	run("Analyze Particles...", "size=100-Infinity show=Masks clear add in_situ"); //refinds all eggs in the image

	for (x = 0; x < roicount; x++) { // inner 'for' loop deletes all eggs (x) that arent the egg selected in the outer 'for' loop (i)
		roiManager("Deselect");
		if (x != i) { // as long as the egg x isn't the focus of the outer for loop (i)...
			roiManager("select", x);  // select the egg x
			run("Clear", "slice"); // delete the egg x
		}//closing 'if'
	}// closing inner for loop, an image should now exist with only one egg (i).
	
	roiManager("deselect") //deselcting any residual ROIs
	roiManager("delete") // clearing all ROIs
	selectWindow("C"+maskingchannel+"-"+title); // returning to original binary image of all eggs
	
}// closing outer for loop, which performs the inner loop for each egg and then returns to original mask of all eggs


//closes all the other channels that are still open
for (j = 0; j < channels; j++) { //iterates through 0 to [channel count -1]
	k = j+1; //add 1 because channels indexing from 1 not 0
	selectWindow("C"+k+"-"+title); 
	close();
}

//creates one multichannel mask
run("Images to Stack", "name=Mask title=[] use"); 

