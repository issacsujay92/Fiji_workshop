input_path = getDirectory("Input folder");
path = getDirectory("Output folder");

fileList = getFileList(input_path); //this is an array of the images
for (i=0; i<fileList.length; i++){
	print(fileList[i]);
	
	//Preparing for next image
	run("Close All");
	run("Clear Results");
	
	//Opening the image
	open(input_path + fileList[i]);
	print(input_path + fileList[i]);
	sample_name = File.nameWithoutExtension;
	
	//Creating a unique folder for each sample
	path2 = path + File.separator + sample_name + File.separator;
	File.makeDirectory(path2);
	
	//creating a unique ID for the raw image
	selectWindow(sample_name + ".png");
	rawimg_id = getImageID();
	
	//setTool("rectangle");
	//makeRectangle(620, 16, 363, 743);
	//run("Crop");
	selectImage(rawimg_id);
	run("Convert to Mask");
	binary_img_id = getImageID();
	run("Duplicate...", "title=watershed");
	selectWindow("watershed");
	watershed_img_id = getImageID();
	print(watershed_img_id);
	run("Invert LUT");
		
	//run watershed (classic FIJI)
	selectImage(watershed_img_id);
	run("Watershed");
		
	//Creating and analyzing pore body mask
	selectImage(watershed_img_id);
	PB_nonlab_title = sample_name + "_" + "Non-labelled pore body mask";
	saveAs("Tiff", path2 + PB_nonlab_title);
	
	selectImage(watershed_img_id);
	run("Set Scale...", "distance=336 known=0.68 unit=cm");
	run("Set Measurements...", "area perimeter bounding fit shape feret's display redirect=None decimal=6");
	run("Analyze Particles...", "display exclude clear include add");
	run("Flatten");
	PB_lab_title = sample_name + "_" + "Labelled pore body mask";
	saveAs("Tiff", path2 + PB_lab_title);
	PB_tab_title = sample_name + "_" + "Pore body stats.csv";
	Table.save(path2 + PB_tab_title);
	
	
	//Creating and analyzing pore throat mask
	imageCalculator("Subtract create", watershed_img_id, binary_img_id);
	throat_img_id = getImageID();
	run("Invert LUT");
	run("Set Measurements...", "area perimeter bounding fit shape feret's display redirect=None decimal=6");
	run("Analyze Particles...", "display exclude clear include add");
	PT_tab_title = sample_name + "_" + "Pore throat stats.csv";
	Table.save(path2 + PT_tab_title);
	
	//Saving non-labelled pore throat mask
	selectImage(throat_img_id);
	PT_nonlab_title = sample_name + "_" + "Non-labelled pore throat mask";
	saveAs("Tiff", path2 + PT_nonlab_title);
	
	//Saving labelled pore throat mask
	run("Flatten");
	PT_lab_title = sample_name + "_" + "Labelled pore throat mask";
	saveAs("Tiff", path2 + PT_lab_title);
		
	//saving the cropped raw image, the binary mask
	selectImage(binary_img_id);
	binary_title = sample_name + "_" + "Binary mask";
	saveAs("Tiff", path2 + binary_title);
	
}
	// closes all images before the next iteration
	//while(nImages > 0) close();